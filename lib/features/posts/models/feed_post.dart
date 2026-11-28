class FeedComment {
  final String id;
  final String authorName;
  final String text;
  final DateTime createdAt;

  const FeedComment({
    required this.id,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FeedComment.fromJson(Map<String, dynamic> json) {
    return FeedComment(
      id: json['id'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Stride Athlete',
      text: json['text'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class FeedPost {
  final String id;
  final String authorName;
  final String? authorPhotoUrl;
  final String title;
  final String caption;
  final String tag;
  final String? imagePath;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final List<FeedComment> comments;

  const FeedPost({
    required this.id,
    required this.authorName,
    required this.title,
    required this.caption,
    required this.createdAt,
    this.authorPhotoUrl,
    this.tag = 'Workout',
    this.imagePath,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const <FeedComment>[],
  });

  FeedPost copyWith({
    String? title,
    String? caption,
    String? tag,
    String? imagePath,
    int? likes,
    bool? isLiked,
    List<FeedComment>? comments,
  }) {
    return FeedPost(
      id: id,
      authorName: authorName,
      authorPhotoUrl: authorPhotoUrl,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      tag: tag ?? this.tag,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'title': title,
      'caption': caption,
      'tag': tag,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isLiked': isLiked,
      'comments': [for (final c in comments) c.toJson()],
    };
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    final rawComments = json['comments'];
    final parsedComments = rawComments is List
        ? [
            for (final entry in rawComments)
              if (entry is Map)
                FeedComment.fromJson(Map<String, dynamic>.from(entry)),
          ]
        : const <FeedComment>[];

    return FeedPost(
      id: json['id'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Stride Athlete',
      authorPhotoUrl: json['authorPhotoUrl'] as String?,
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      tag: json['tag'] as String? ?? 'Workout',
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      comments: List.unmodifiable(parsedComments),
    );
  }
}