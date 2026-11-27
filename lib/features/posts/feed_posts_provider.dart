import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/post_store.dart';

final postStoreProvider = Provider<PostStore>((ref) {
  return FirestorePostStore();
});

class FeedPostsNotifier extends Notifier<List<FeedPost>> {
  PostStore get _store => ref.read(postStoreProvider);

  @override
  List<FeedPost> build() => const <FeedPost>[];

  Future<void> load() async {
    try {
      final posts = await _store.readAll();
      state = List.unmodifiable(posts);
    } catch (_) {
      return;
    }
  }

  Future<void> create(FeedPost post) async {
    final next = [
      post,
      for (final item in state)
        if (item.id != post.id) item,
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = List.unmodifiable(next);
    await _store.save(post);
  }

  Future<void> toggleLike(String id) async {
    FeedPost? updated;
    final next = [
      for (final item in state)
        if (item.id == id)
          updated = item.copyWith(
            isLiked: !item.isLiked,
            likes: item.isLiked
                ? (item.likes > 0 ? item.likes - 1 : 0)
                : item.likes + 1,
          )
        else
          item,
    ];
    if (updated == null) return;
    state = List.unmodifiable(next);
    await _store.save(updated);
  }

  Future<void> remove(String id) async {
    final next = state.where((item) => item.id != id).toList();
    if (next.length == state.length) return;
    state = List.unmodifiable(next);
    await _store.remove(id);
  }
}

final feedPostsProvider =
    NotifierProvider<FeedPostsNotifier, List<FeedPost>>(
  FeedPostsNotifier.new,
);