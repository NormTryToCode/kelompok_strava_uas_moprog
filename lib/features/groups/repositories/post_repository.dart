import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';

class PostRepository {
  static const _collection = 'posts';
  final _db = DatabaseService.instance;

  Future<ClubPost> _updatePost(
    String postId,
    ClubPost Function(ClubPost current) transform,
  ) async {
    final rows = await _db.getWhere(_collection, 'id', postId);
    if (rows.isEmpty) {
      throw StateError('Post not found: $postId');
    }

    final updated = transform(ClubPost.fromJson(rows.first));
    await _db.save(_collection, updated.id, updated.toJson());
    return updated;
  }

  Future<List<ClubPost>> getPostsByClub(String clubId) async {
    final rows = await _db.getWhere(_collection, 'clubId', clubId);
    final clubPosts = rows.map(ClubPost.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return clubPosts;
  }

  Future<ClubPost> createPost(ClubPost post) async {
    await _db.save(_collection, post.id, post.toJson());
    return post;
  }

  Future<void> deletePost(String postId) => _db.remove(_collection, postId);

  Future<ClubPost> toggleKudos(String postId) {
    return _updatePost(postId, (post) {
      final giving = !post.hasGivenKudos;
      final nextCount = giving
          ? post.kudosCount + 1
          : (post.kudosCount > 0 ? post.kudosCount - 1 : 0);
      return post.copyWith(hasGivenKudos: giving, kudosCount: nextCount);
    });
  }

  Future<ClubPost> addComment({
    required String postId,
    required PostComment comment,
  }) {
    return _updatePost(postId, (post) {
      if (!post.allowComments) return post;
      return post.copyWith(comments: [...post.comments, comment]);
    });
  }

  Future<ClubPost> toggleCommentLike({
    required String postId,
    required String commentId,
  }) {
    return _updatePost(postId, (post) {
      final updatedComments = [
        for (final comment in post.comments)
          if (comment.id == commentId)
            comment.copyWith(
              isLikedByMe: !comment.isLikedByMe,
              likeCount: !comment.isLikedByMe
                  ? comment.likeCount + 1
                  : (comment.likeCount > 0 ? comment.likeCount - 1 : 0),
            )
          else
            comment,
      ];
      return post.copyWith(comments: updatedComments);
    });
  }

  Future<ClubPost> deleteComment({
    required String postId,
    required String commentId,
  }) {
    return _updatePost(postId, (post) {
      return post.copyWith(
        comments: post.comments.where((c) => c.id != commentId).toList(),
      );
    });
  }
}