import 'dart:convert';

import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PostJsonMap = Map<String, dynamic>;
typedef PostReadAll = Future<List<PostJsonMap>> Function(String collection);
typedef PostSaveDoc = Future<void> Function(
  String collection,
  String id,
  PostJsonMap data,
);
typedef PostRemoveDoc = Future<void> Function(String collection, String id);

abstract class PostStore {
  Future<List<FeedPost>> readAll();

  Future<void> save(FeedPost post);

  Future<void> remove(String id);
}

class PrefsPostStore implements PostStore {
  static const String _key = 'standalone_feed_posts';

  SharedPreferencesAsync? _cache;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  @override
  Future<List<FeedPost>> readAll() async {
    final raw = await _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const <FeedPost>[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    final list = [
      for (final entry in decoded) FeedPost.fromJson(entry as PostJsonMap),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> _writeAll(List<FeedPost> posts) {
    return _prefs.setString(
      _key,
      jsonEncode([for (final post in posts) post.toJson()]),
    );
  }

  @override
  Future<void> save(FeedPost post) async {
    final current = await readAll();
    final next = [
      post,
      for (final item in current)
        if (item.id != post.id) item,
    ];
    await _writeAll(next);
  }

  @override
  Future<void> remove(String id) async {
    final current = await readAll();
    await _writeAll(current.where((item) => item.id != id).toList());
  }
}

class FirestorePostStore implements PostStore {
  static const String collectionName = 'feed_posts';

  final PostStore _fallback;
  final PostReadAll? _readAll;
  final PostSaveDoc? _saveDoc;
  final PostRemoveDoc? _removeDoc;

  FirestorePostStore({
    PostStore? fallback,
    PostReadAll? readAll,
    PostSaveDoc? saveDoc,
    PostRemoveDoc? removeDoc,
  })  : _fallback = fallback ?? PrefsPostStore(),
        _readAll = readAll,
        _saveDoc = saveDoc,
        _removeDoc = removeDoc;

  @override
  Future<List<FeedPost>> readAll() async {
    try {
      final reader = _readAll ?? DatabaseService.instance.getAll;
      final docs = await reader(collectionName);
      final posts = [for (final doc in docs) FeedPost.fromJson(doc)]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return posts;
    } catch (_) {}
    try {
      return await _fallback.readAll();
    } catch (_) {
      return const <FeedPost>[];
    }
  }

  @override
  Future<void> save(FeedPost post) async {
    try {
      await _fallback.save(post);
    } catch (_) {}
    try {
      final writer = _saveDoc ?? DatabaseService.instance.save;
      await writer(collectionName, post.id, post.toJson());
    } catch (_) {
      return;
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await _fallback.remove(id);
    } catch (_) {}
    try {
      final remover = _removeDoc ?? DatabaseService.instance.remove;
      await remover(collectionName, id);
    } catch (_) {
      return;
    }
  }
}

class MemoryPostStore implements PostStore {
  final List<FeedPost> _items;

  MemoryPostStore([List<FeedPost>? initial])
      : _items = List<FeedPost>.from(initial ?? const <FeedPost>[]);

  @override
  Future<List<FeedPost>> readAll() async {
    final copy = List<FeedPost>.from(_items)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return copy;
  }

  @override
  Future<void> save(FeedPost post) async {
    _items.removeWhere((item) => item.id == post.id);
    _items.insert(0, post);
  }

  @override
  Future<void> remove(String id) async {
    _items.removeWhere((item) => item.id == id);
  }
}