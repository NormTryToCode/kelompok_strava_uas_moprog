import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

class ClubPostsNotifier extends FamilyAsyncNotifier<List<ClubPost>, String> {
  PostRepository get _repository => ref.read(postRepositoryProvider);

  @override
  Future<List<ClubPost>> build(String arg) async {
    return _repository.getPostsByClub(arg);
  }

  void _replacePost(ClubPost updated) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final post in current)
        if (post.id == updated.id) updated else post,
    ]);
  }

  Future<ClubPost> createPost({
    required String authorName,
    required PostAuthorRole authorRole,
    required String title,
    required String body,
    PostTag tag = PostTag.general,
    String? imagePath,
    bool allowComments = true,
  }) async {
    final now = DateTime.now();
    final post = ClubPost(
      id: now.microsecondsSinceEpoch.toString(),
      clubId: arg,
      authorName: authorName.trim(),
      authorRole: authorRole,
      title: title.trim(),
      body: body.trim(),
      tag: tag,
      imagePath: imagePath,
      allowComments: allowComments,
      createdAt: now,
    );

    final created = await _repository.createPost(post);
    final current = state.valueOrNull ?? [];
    state = AsyncData([created, ...current]);
    return created;
  }

  Future<void> deletePost(String postId) async {
    await _repository.deletePost(postId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((p) => p.id != postId).toList());
  }

  Future<void> toggleKudos(String postId) async {
    final updated = await _repository.toggleKudos(postId);
    _replacePost(updated);
  }

  Future<void> addComment({
    required String postId,
    required String content,
    String authorName = 'You',
    bool isCurrentUser = true,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final comment = PostComment(
      id: now.microsecondsSinceEpoch.toString(),
      authorName: authorName,
      content: trimmed,
      createdAt: now,
      isCurrentUser: isCurrentUser,
    );

    final updated = await _repository.addComment(
      postId: postId,
      comment: comment,
    );
    _replacePost(updated);
  }

  Future<void> toggleCommentLike({
    required String postId,
    required String commentId,
  }) async {
    final updated = await _repository.toggleCommentLike(
      postId: postId,
      commentId: commentId,
    );
    _replacePost(updated);
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final updated = await _repository.deleteComment(
      postId: postId,
      commentId: commentId,
    );
    _replacePost(updated);
  }
}

final clubPostsProvider =
    AsyncNotifierProvider.family<ClubPostsNotifier, List<ClubPost>, String>(
  ClubPostsNotifier.new,
);