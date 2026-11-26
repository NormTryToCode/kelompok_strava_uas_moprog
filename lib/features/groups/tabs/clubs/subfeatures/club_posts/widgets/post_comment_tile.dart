import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';

class PostCommentTile extends StatelessWidget {
  final PostComment comment;
  final VoidCallback onToggleLike;
  final VoidCallback? onDelete;

  const PostCommentTile({
    super.key,
    required this.comment,
    required this.onToggleLike,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final initial = comment.authorName.trim().isEmpty
        ? 'A'
        : comment.authorName.trim().substring(0, 1).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Styles.selectedFill,
              border: Border.all(color: Styles.teal.withAlpha(140)),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Styles.teal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      ' \u00b7 ',
                      style: TextStyle(color: Styles.textSecondary),
                    ),
                    Text(
                      comment.createdAt.timeAgo(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: onToggleLike,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          comment.isLikedByMe
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: comment.isLikedByMe
                              ? Styles.accent
                              : Styles.textSecondary,
                        ),
                        if (comment.likeCount > 0) ...[
                          const SizedBox(width: 5),
                          Text(
                            '${comment.likeCount}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: comment.isLikedByMe
                                  ? Styles.accent
                                  : Styles.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (comment.isCurrentUser && onDelete != null)
            IconButton(
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: Styles.textSecondary,
              ),
              tooltip: 'Delete comment',
            ),
        ],
      ),
    );
  }
}

