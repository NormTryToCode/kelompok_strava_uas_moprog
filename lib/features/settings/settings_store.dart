import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SettingsJsonMap = Map<String, dynamic>;
typedef SettingsReadAll = Future<List<SettingsJsonMap>> Function(
  String collection,
);
typedef SettingsSaveDoc = Future<void> Function(
  String collection,
  String id,
  SettingsJsonMap data,
);

abstract class SettingsStore {
  Future<String?> readString(String key);

  Future<void> writeString(String key, String value);

  Future<bool?> readBool(String key);

  Future<void> writeBool(String key, bool value);
}

class PrefsSettingsStore implements SettingsStore {
  SharedPreferencesAsync? _cache;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  @override
  Future<String?> readString(String key) => _prefs.getString(key);

  @override
  Future<void> writeString(String key, String value) {
    return _prefs.setString(key, value);
  }

  @override
  Future<bool?> readBool(String key) => _prefs.getBool(key);

  @override
  Future<void> writeBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }
}

class FirestoreSettingsStore implements SettingsStore {
  static const String collectionName = 'user_settings';
  static const String docId = defaultStorageUserId;

  final SettingsStore _fallback;
  final SettingsReadAll? _readAll;
  final SettingsSaveDoc? _saveDoc;
  final String Function() _userId;
  final Map<String, Object> _remoteCache = {};
  String? _fetchedUid;

  FirestoreSettingsStore({
    SettingsStore? fallback,
    SettingsReadAll? readAll,
    SettingsSaveDoc? saveDoc,
    String Function()? userId,
  })  : _fallback = fallback ?? PrefsSettingsStore(),
        _readAll = readAll,
        _saveDoc = saveDoc,
        _userId = userId ?? resolveStorageUserId;

  Future<void> _ensureFetched() async {
    final activeDocId = _userId();
    if (_fetchedUid == activeDocId) return;
    _fetchedUid = activeDocId;
    _remoteCache.clear();
    try {
      final reader = _readAll ?? DatabaseService.instance.getAll;
      final docs = await reader(collectionName);
      for (final doc in docs) {
        if (doc['id'] == activeDocId) {
          doc.forEach((key, value) {
            if (key != 'id' && value is Object) {
              _remoteCache[key] = value;
            }
          });
          break;
        }
      }
    } catch (_) {
      return;
    }
  }

  Future<void> _syncRemote() async {
    try {
      final writer = _saveDoc ?? DatabaseService.instance.save;
      await writer(
        collectionName,
        _userId(),
        SettingsJsonMap.from(_remoteCache),
      );
    } catch (_) {
      return;
    }
  }

  @override
  Future<String?> readString(String key) async {
    await _ensureFetched();
    final remote = _remoteCache[key];
    if (remote is String) return remote;
    return _fallback.readString(key);
  }

  @override
  Future<void> writeString(String key, String value) async {
    await _ensureFetched();
    _remoteCache[key] = value;
    try {
      await _fallback.writeString(key, value);
    } catch (_) {}
    await _syncRemote();
  }

  @override
  Future<bool?> readBool(String key) async {
    await _ensureFetched();
    final remote = _remoteCache[key];
    if (remote is bool) return remote;
    return _fallback.readBool(key);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _ensureFetched();
    _remoteCache[key] = value;
    try {
      await _fallback.writeBool(key, value);
    } catch (_) {}
    await _syncRemote();
  }
}

class MemorySettingsStore implements SettingsStore {
  final Map<String, Object> _data = {};

  @override
  Future<String?> readString(String key) async {
    final value = _data[key];
    return value is String ? value : null;
  }

  @override
  Future<void> writeString(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<bool?> readBool(String key) async {
    final value = _data[key];
    return value is bool ? value : null;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    _data[key] = value;
  }
}