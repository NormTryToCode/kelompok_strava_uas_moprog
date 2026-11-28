class FeedPost {
  final String id;
  final String authorName;
  final String title;
  final String caption;
  final String? imagePath;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;

  const FeedPost({
    required this.id,
    required this.authorName,
    required this.title,
    required this.caption,
    required this.createdAt,
    this.imagePath,
    this.likes = 0,
    this.isLiked = false,
  });

  FeedPost copyWith({
    String? title,
    String? caption,
    String? imagePath,
    int? likes,
    bool? isLiked,
  }) {
    return FeedPost(
      id: id,
      authorName: authorName,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'title': title,
      'caption': caption,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isLiked': isLiked,
    };
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Stride Athlete',
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }
}