import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FirestoreReadAll = Future<List<JsonMap>> Function(String collection);
typedef FirestoreSaveDoc = Future<void> Function(
  String collection,
  String id,
  JsonMap data,
);

abstract class ActivityStore {
  Future<String?> read();

  Future<void> write(String json);
}

class PrefsActivityStore implements ActivityStore {
  static const String _key = 'manual_activities';

  SharedPreferencesAsync? _cache;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  @override
  Future<String?> read() => _prefs.getString(_key);

  @override
  Future<void> write(String json) => _prefs.setString(_key, json);
}

class FirestoreActivityStore implements ActivityStore {
  static const String collectionName = 'manual_activities_store';
  static const String docId = defaultStorageUserId;

  final ActivityStore _fallback;
  final FirestoreReadAll? _readAll;
  final FirestoreSaveDoc? _saveDoc;
  final String Function() _userId;

  FirestoreActivityStore({
    ActivityStore? fallback,
    FirestoreReadAll? readAll,
    FirestoreSaveDoc? saveDoc,
    String Function()? userId,
  })  : _fallback = fallback ?? PrefsActivityStore(),
        _readAll = readAll,
        _saveDoc = saveDoc,
        _userId = userId ?? resolveStorageUserId;

  Future<List<JsonMap>> _getAll(String collection) {
    final reader = _readAll ?? DatabaseService.instance.getAll;
    return reader(collection);
  }

  Future<void> _save(String collection, String id, JsonMap data) {
    final writer = _saveDoc ?? DatabaseService.instance.save;
    return writer(collection, id, data);
  }

  @override
  Future<String?> read() async {
    final activeDocId = _userId();
    try {
      final docs = await _getAll(collectionName);
      for (final doc in docs) {
        if (doc['id'] == activeDocId && doc['payload'] is String) {
          return doc['payload'] as String;
        }
      }
    } catch (_) {}
    return _fallback.read();
  }

  @override
  Future<void> write(String json) async {
    try {
      await _fallback.write(json);
    } catch (_) {}
    try {
      await _save(collectionName, _userId(), {
        'payload': json,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return;
    }
  }
}

class MemoryActivityStore implements ActivityStore {
  String? _json;

  MemoryActivityStore([this._json]);

  @override
  Future<String?> read() async => _json;

  @override
  Future<void> write(String json) async {
    _json = json;
  }
}