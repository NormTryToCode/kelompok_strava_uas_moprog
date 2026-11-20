import 'dart:convert';
import 'dart:io';

import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:path_provider/path_provider.dart';

class PostRepository {
  static const _fileName = 'posts.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  Future<List<ClubPost>> _readAll() async {
    final file = await _file();
    if (!await file.exists()) return [];

    try {
      final data = jsonDecode(await file.readAsString());
      final list = data is Map ? data['posts'] : null;
      if (list is! List) return [];
      return [
        for (final item in list)
          if (item is Map<String, dynamic>) ClubPost.fromJson(item),
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeAll(List<ClubPost> posts) async {
    final file = await _file();
    final temp = File('${file.path}.tmp');
    final content = const JsonEncoder.withIndent('  ').convert({
      'posts': posts.map((p) => p.toJson()).toList(),
    });

    await temp.writeAsString(content, flush: true);
    await temp.rename(file.path);
  }

  Future<ClubPost> _updatePost(
    String postId,
    ClubPost Function(ClubPost current) transform,
  ) async {
    final all = await _readAll();
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

    await _writeAll(updatedList);
    return updatedPost;
  }

  Future<List<ClubPost>> getPostsByClub(String clubId) async {
    final all = await _readAll();
    final clubPosts = all.where((p) => p.clubId == clubId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return clubPosts;
  }

  Future<ClubPost> createPost(ClubPost post) async {
    final all = await _readAll();
    await _writeAll([post, ...all]);
    return post;
  }

  Future<void> deletePost(String postId) async {
    final all = await _readAll();
    final updated = all.where((p) => p.id != postId).toList();
    await _writeAll(updated);
  }

  Future<ClubPost> toggleKudos(String postId) {
    return _updatePost(postId, (post) {
      final giving = !post.hasGivenKudos;
      final nextCount = giving
          ? post.kudosCount + 1
          : (post.kudosCount > 0 ? post.kudosCount - 1 : 0);
      return post.copyWith(
        hasGivenKudos: giving,
        kudosCount: nextCount,
      );
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
      final remaining =
          post.comments.where((c) => c.id != commentId).toList();
      return post.copyWith(comments: remaining);
    });
  }
}