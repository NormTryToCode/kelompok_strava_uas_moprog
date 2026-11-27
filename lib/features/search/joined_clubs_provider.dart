import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef JoinedClubJson = Map<String, dynamic>;
typedef JoinedClubReadAll = Future<List<JoinedClubJson>> Function(
  String collection,
);
typedef JoinedClubSaveDoc = Future<void> Function(
  String collection,
  String id,
  JoinedClubJson data,
);

abstract class JoinedClubsStore {
  Future<Set<String>> read();

  Future<void> write(Set<String> ids);
}

class PrefsJoinedClubsStore implements JoinedClubsStore {
  static const String _key = 'joined_club_ids';

  SharedPreferencesAsync? _cache;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  @override
  Future<Set<String>> read() async {
    final list = await _prefs.getStringList(_key);
    return list == null ? <String>{} : list.toSet();
  }

  @override
  Future<void> write(Set<String> ids) {
    return _prefs.setStringList(_key, ids.toList(growable: false));
  }
}

class FirestoreJoinedClubsStore implements JoinedClubsStore {
  static const String collectionName = 'user_joined_clubs';

  final JoinedClubsStore _fallback;
  final JoinedClubReadAll? _readAll;
  final JoinedClubSaveDoc? _saveDoc;
  final String Function() _userId;

  FirestoreJoinedClubsStore({
    JoinedClubsStore? fallback,
    JoinedClubReadAll? readAll,
    JoinedClubSaveDoc? saveDoc,
    String Function()? userId,
  })  : _fallback = fallback ?? PrefsJoinedClubsStore(),
        _readAll = readAll,
        _saveDoc = saveDoc,
        _userId = userId ?? resolveStorageUserId;

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
    } catch (_) {}
    try {
      return await _fallback.read();
    } catch (_) {
      return <String>{};
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

class MemoryJoinedClubsStore implements JoinedClubsStore {
  Set<String> _ids;

  MemoryJoinedClubsStore([Set<String>? initial]) : _ids = {...?initial};

  @override
  Future<Set<String>> read() async => {..._ids};

  @override
  Future<void> write(Set<String> ids) async {
    _ids = {...ids};
  }
}

final joinedClubsStoreProvider = Provider<JoinedClubsStore>((ref) {
  return FirestoreJoinedClubsStore();
});

class JoinedClubsNotifier extends Notifier<Set<String>> {
  JoinedClubsStore get _store => ref.read(joinedClubsStoreProvider);

  @override
  Set<String> build() => const <String>{};

  Future<void> load() async {
    try {
      state = Set.unmodifiable(await _store.read());
    } catch (_) {
      return;
    }
  }

  bool toggle(String clubId) {
    final next = {...state};
    final joined = !next.remove(clubId);
    if (joined) {
      next.add(clubId);
    }
    state = Set.unmodifiable(next);
    unawaited(_persist(next));
    return joined;
  }

  Future<void> _persist(Set<String> ids) async {
    try {
      await _store.write(ids);
    } catch (_) {
      return;
    }
  }
}

final joinedClubsProvider =
    NotifierProvider<JoinedClubsNotifier, Set<String>>(
  JoinedClubsNotifier.new,
);