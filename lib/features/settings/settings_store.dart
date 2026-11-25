import 'package:shared_preferences/shared_preferences.dart';

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