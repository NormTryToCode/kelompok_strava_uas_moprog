import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/local_json_store.dart';

class PostRepository {
  final _store = LocalJsonStore<ClubPost>(
    fileName: 'posts.json',
    rootKey: 'posts',
    fromJson: ClubPost.fromJson,
    toJson: (p) => p.toJson(),
  );

  Future<ClubPost> _updatePost(
    String postId,
    ClubPost Function(ClubPost current) transform,
  ) async {
    final all = await _store.readAll();
    ClubPost? updatedPost;

    final updatedList = <ClubPost>[];
    for (final post in all) {
      if (post.id == postId) {
        updatedPost = transform(post);
        updatedList.add(updatedPost);
      } else {
        updatedList.add(post);
      }
    }

    if (updatedPost == null) {
      throw StateError('Post not found: $postId');
    }

    await _store.writeAll(updatedList);
    return updatedPost;
  }

  Future<List<ClubPost>> getPostsByClub(String clubId) async {
    final all = await _store.readAll();
    final clubPosts = all.where((p) => p.clubId == clubId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return clubPosts;
  }

  Future<ClubPost> createPost(ClubPost post) async {
    final all = await _store.readAll();
    await _store.writeAll([post, ...all]);
    return post;
  }

  Future<void> deletePost(String postId) async {
    final all = await _store.readAll();
    await _store.writeAll(all.where((p) => p.id != postId).toList());
  }

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