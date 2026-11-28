import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
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

  Future<void> toggleLike(String id, {String? userId}) async {
    final uid = userId ?? resolveStorageUserId();
    FeedPost? updated;
    final next = [
      for (final item in state)
        if (item.id == id)
          updated = _toggleLikeForUser(item, uid)
        else
          item,
    ];
    if (updated == null) return;
    state = List.unmodifiable(next);
    await _store.save(updated);
  }

  FeedPost _toggleLikeForUser(FeedPost item, String uid) {
    final nextLikedBy = List<String>.from(item.likedBy);
    final alreadyLiked = item.isLikedBy(uid);

    if (alreadyLiked) {
      nextLikedBy.remove(uid);
      final nextCount = item.likes > 0 ? item.likes - 1 : 0;
      return item.copyWith(
        isLiked: false,
        likes: nextCount,
        likedBy: List.unmodifiable(nextLikedBy),
      );
    }

    if (!nextLikedBy.contains(uid)) {
      nextLikedBy.add(uid);
    }
    return item.copyWith(
      isLiked: true,
      likes: item.likes + 1,
      likedBy: List.unmodifiable(nextLikedBy),
    );
  }

  Future<void> addComment(String postId, FeedComment comment) async {
    FeedPost? updated;
    final next = [
      for (final item in state)
        if (item.id == postId)
          updated = item.copyWith(
            comments: List.unmodifiable([...item.comments, comment]),
          )
        else
          item,
    ];
    if (updated == null) return;
    state = List.unmodifiable(next);
    await _store.save(updated);
  }

  Future<void> remove(String id, {String? requesterId}) async {
    FeedPost? target;
    for (final item in state) {
      if (item.id == id) {
        target = item;
        break;
      }
    }
    if (target == null) return;
    if (requesterId != null &&
        target.authorId.isNotEmpty &&
        target.authorId != requesterId) {
      return;
    }

    final next = state.where((item) => item.id != id).toList();
    state = List.unmodifiable(next);
    await _store.remove(id);
  }
}

final feedPostsProvider =
    NotifierProvider<FeedPostsNotifier, List<FeedPost>>(
  FeedPostsNotifier.new,
);