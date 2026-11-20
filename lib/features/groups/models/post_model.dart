import 'package:flutter/material.dart';

enum PostAuthorRole {
  club(
    label: 'Club Official',
    subtitle: 'Post on behalf of the club',
    icon: Icons.flag_outlined,
  ),
  member(
    label: 'Personal Profile',
    subtitle: 'Post using your athlete name',
    icon: Icons.person_outline,
  );

  final String label;
  final String subtitle;
  final IconData icon;

  const PostAuthorRole({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

enum PostTag {
  general(label: 'General', icon: Icons.article_outlined),
  recap(label: 'Recap', icon: Icons.directions_run),
  route(label: 'Route Tip', icon: Icons.alt_route),
  gear(label: 'Gear Talk', icon: Icons.backpack_outlined);

  final String label;
  final IconData icon;

  const PostTag({required this.label, required this.icon});
}

class PostComment {
  final String id;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final bool isCurrentUser;
  final int likeCount;
  final bool isLikedByMe;

  const PostComment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
    this.isCurrentUser = true,
    this.likeCount = 0,
    this.isLikedByMe = false,
  });

  PostComment copyWith({
    String? id,
    String? authorName,
    String? content,
    DateTime? createdAt,
    bool? isCurrentUser,
    int? likeCount,
    bool? isLikedByMe,
  }) {
    return PostComment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      likeCount: likeCount ?? this.likeCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isCurrentUser': isCurrentUser,
        'likeCount': likeCount,
        'isLikedByMe': isLikedByMe,
      };

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Athlete',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
    );
  }
}

class ClubPost {
  final String id;
  final String clubId;
  final String authorName;
  final PostAuthorRole authorRole;
  final String title;
  final String body;
  final PostTag tag;
  final String? imagePath;
  final bool allowComments;
  final int kudosCount;
  final bool hasGivenKudos;
  final DateTime createdAt;
  final List<PostComment> comments;

  const ClubPost({
    required this.id,
    required this.clubId,
    required this.authorName,
    required this.title,
    required this.body,
    required this.createdAt,
    this.authorRole = PostAuthorRole.club,
    this.tag = PostTag.general,
    this.imagePath,
    this.allowComments = true,
    this.kudosCount = 0,
    this.hasGivenKudos = false,
    this.comments = const [],
  });

  String get kudosLabel {
    if (kudosCount == 0) return 'Be the first to give kudos!';
    return kudosCount == 1 ? '1 kudo' : '$kudosCount kudos';
  }

  String get commentLabel {
    if (comments.isEmpty) return '';
    return comments.length == 1 ? '1 comment' : '${comments.length} comments';
  }

  ClubPost copyWith({
    String? id,
    String? clubId,
    String? authorName,
    PostAuthorRole? authorRole,
    String? title,
    String? body,
    PostTag? tag,
    String? imagePath,
    bool clearImage = false,
    bool? allowComments,
    int? kudosCount,
    bool? hasGivenKudos,
    DateTime? createdAt,
    List<PostComment>? comments,
  }) {
    return ClubPost(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      title: title ?? this.title,
      body: body ?? this.body,
      tag: tag ?? this.tag,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      allowComments: allowComments ?? this.allowComments,
      kudosCount: kudosCount ?? this.kudosCount,
      hasGivenKudos: hasGivenKudos ?? this.hasGivenKudos,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clubId': clubId,
        'authorName': authorName,
        'authorRole': authorRole.name,
        'title': title,
        'body': body,
        'tag': tag.name,
        'imagePath': imagePath,
        'allowComments': allowComments,
        'kudosCount': kudosCount,
        'hasGivenKudos': hasGivenKudos,
        'createdAt': createdAt.toIso8601String(),
        'comments': comments.map((c) => c.toJson()).toList(),
      };

  factory ClubPost.fromJson(Map<String, dynamic> json) {
    final rawComments = json['comments'];

    return ClubPost(
      id: json['id'] as String? ?? '',
      clubId: json['clubId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorRole: PostAuthorRole.values.firstWhere(
        (r) => r.name == json['authorRole'],
        orElse: () => PostAuthorRole.club,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tag: PostTag.values.firstWhere(
        (t) => t.name == json['tag'],
        orElse: () => PostTag.general,
      ),
      imagePath: json['imagePath'] as String?,
      allowComments: json['allowComments'] as bool? ?? true,
      kudosCount: (json['kudosCount'] as num?)?.toInt() ?? 0,
      hasGivenKudos: json['hasGivenKudos'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      comments: [
        if (rawComments is List)
          for (final item in rawComments)
            if (item is Map<String, dynamic>) PostComment.fromJson(item),
      ],
    );
  }
}