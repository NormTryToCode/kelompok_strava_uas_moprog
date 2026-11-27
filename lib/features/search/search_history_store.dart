import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef HistoryJsonMap = Map<String, dynamic>;
typedef HistoryReadAll = Future<List<HistoryJsonMap>> Function(
  String collection,
);
typedef HistorySaveDoc = Future<void> Function(
  String collection,
  String id,
  HistoryJsonMap data,
);

abstract class SearchHistoryStore {
  Future<List<String>> read();

  Future<void> write(List<String> items);
}

class PrefsSearchHistoryStore implements SearchHistoryStore {
  static const String _key = 'search_history_items';

  SharedPreferencesAsync? _cache;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  @override
  Future<List<String>> read() async {
    return (await _prefs.getStringList(_key)) ?? const <String>[];
  }

  @override
  Future<void> write(List<String> items) => _prefs.setStringList(_key, items);
}

class FirestoreSearchHistoryStore implements SearchHistoryStore {
  static const String collectionName = 'user_search_history';

  final SearchHistoryStore _fallback;
  final HistoryReadAll? _readAll;
  final HistorySaveDoc? _saveDoc;
  final String Function() _userId;

  FirestoreSearchHistoryStore({
    SearchHistoryStore? fallback,
    HistoryReadAll? readAll,
    HistorySaveDoc? saveDoc,
    String Function()? userId,
  })  : _fallback = fallback ?? PrefsSearchHistoryStore(),
        _readAll = readAll,
        _saveDoc = saveDoc,
        _userId = userId ?? resolveStorageUserId;

  @override
  Future<List<String>> read() async {
    final docId = _userId();
    try {
      final reader = _readAll ?? DatabaseService.instance.getAll;
      final docs = await reader(collectionName);
      for (final doc in docs) {
        if (doc['id'] == docId && doc['items'] is List) {
          return (doc['items'] as List).whereType<String>().toList();
        }
      }
    } catch (_) {}
    try {
      return await _fallback.read();
    } catch (_) {
      return const <String>[];
    }
  }

  @override
  Future<void> write(List<String> items) async {
    try {
      await _fallback.write(items);
    } catch (_) {}
    try {
      final writer = _saveDoc ?? DatabaseService.instance.save;
      await writer(collectionName, _userId(), {
        'items': items,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return;
    }
  }
}

class MemorySearchHistoryStore implements SearchHistoryStore {
  List<String> _items;

  MemorySearchHistoryStore([List<String>? initial])
      : _items = List<String>.from(initial ?? const <String>[]);

  @override
  Future<List<String>> read() async => List<String>.from(_items);

  @override
  Future<void> write(List<String> items) async {
    _items = List<String>.from(items);
  }
}