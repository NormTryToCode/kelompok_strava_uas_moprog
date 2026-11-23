import 'package:shared_preferences/shared_preferences.dart';

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