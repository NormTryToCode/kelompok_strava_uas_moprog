import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef FollowJsonMap = Map<String, dynamic>;
typedef FollowReadAll = Future<List<FollowJsonMap>> Function(String collection);
typedef FollowSaveDoc = Future<void> Function(
  String collection,
  String id,
  FollowJsonMap data,
);

abstract class FollowStore {
  Future<Set<String>> read();

  Future<void> write(Set<String> ids);
}

class PrefsFollowStore implements FollowStore {
  static const String _keyPrefix = 'following_ids';

  final String Function() _userId;
  SharedPreferencesAsync? _cache;

  PrefsFollowStore({String Function()? userId})
      : _userId = userId ?? resolveStorageUserId;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  String get _scopedKey => '${_keyPrefix}_${_userId()}';

  @override
  Future<Set<String>> read() async {
    final list = await _prefs.getStringList(_scopedKey);
    return list == null ? <String>{} : list.toSet();
  }

  @override
  Future<void> write(Set<String> ids) {
    return _prefs.setStringList(_scopedKey, ids.toList(growable: false));
  }
}

class FirestoreFollowStore implements FollowStore {
  static const String collectionName = 'user_following';

  final FollowStore _fallback;
  final FollowReadAll? _readAll;
  final FollowSaveDoc? _saveDoc;
  final String Function() _userId;

  FirestoreFollowStore({
    FollowStore? fallback,
    FollowReadAll? readAll,
    FollowSaveDoc? saveDoc,
    String Function()? userId,
  })  : _userId = userId ?? resolveStorageUserId,
        _fallback = fallback ?? PrefsFollowStore(userId: userId),
        _readAll = readAll,
        _saveDoc = saveDoc;

  @override
  Future<Set<String>> read() async {
    final docId = _userId();
    try {
      final reader = _readAll ?? DatabaseService.instance.getAll;
      final docs = await reader(collectionName);
      for (final doc in docs) {
        if (doc['id'] == docId && doc['ids'] is List) {
          return (doc['ids'] as List).whereType<String>().toSet();
        }
      }
      return <String>{};
    } catch (_) {
      try {
        return await _fallback.read();
      } catch (_) {
        return <String>{};
      }
    }
  }

  @override
  Future<void> write(Set<String> ids) async {
    try {
      await _fallback.write(ids);
    } catch (_) {}
    try {
      final writer = _saveDoc ?? DatabaseService.instance.save;
      await writer(collectionName, _userId(), {
        'ids': ids.toList(growable: false),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return;
    }
  }
}

class MemoryFollowStore implements FollowStore {
  Set<String> _ids;

  MemoryFollowStore([Set<String>? initial]) : _ids = {...?initial};

  @override
  Future<Set<String>> read() async => {..._ids};

  @override
  Future<void> write(Set<String> ids) async {
    _ids = {...ids};
  }
}