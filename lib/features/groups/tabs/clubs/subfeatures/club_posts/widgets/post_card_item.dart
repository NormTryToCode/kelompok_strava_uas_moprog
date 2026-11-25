import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class PostCardItem extends StatelessWidget {
  final Club club;
  final ClubPost post;
  final VoidCallback onToggleKudos;
  final VoidCallback onTapComment;
  final VoidCallback? onTapCard;
  final VoidCallback? onDelete;
  final bool isDetail;

  const PostCardItem({
    super.key,
    required this.club,
    required this.post,
    required this.onToggleKudos,
    required this.onTapComment,
    this.onTapCard,
    this.onDelete,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = post.imagePath;

    return SoftCard(
      onTap: isDetail ? null : onTapCard,
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PostAuthorAvatar(club: club, post: post),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.createdAt.timeAgo(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Styles.surfaceHighlight,
                      ),
                    ),
                  ],
                ),
              ),
              _TagBadge(tag: post.tag),
              if (onDelete != null) ...[
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Styles.surfaceHighlight,
                  ),
                  color: Styles.surface,
                  onSelected: (value) {
                    if (value == 'delete') onDelete!();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Styles.accent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete post',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (post.title.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: Colors.white,
              ),
            ),
          ],
          if (post.body.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              post.body,
              maxLines: isDetail ? null : 4,
              overflow: isDetail ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: Styles.surfaceHighlight,
              ),
            ),
          ],
          if (imagePath != null && imagePath.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 120,
                  width: double.infinity,
                  color: Styles.fieldFill,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Styles.surfaceHighlight,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                post.kudosLabel,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: post.kudosCount > 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: post.hasGivenKudos
                      ? Styles.teal
                      : Styles.surfaceHighlight,
                ),
              ),
              const Spacer(),
              if (!post.allowComments)
                const Text(
                  'Comments off',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Styles.surfaceHighlight,
                  ),
                )
              else if (post.commentLabel.isNotEmpty)
                Text(
                  post.commentLabel,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Styles.surfaceHighlight,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Styles.cardBorder),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionPillButton(
                  icon: post.hasGivenKudos
                      ? Icons.thumb_up_alt_rounded
                      : Icons.thumb_up_alt_outlined,
                  label: post.hasGivenKudos ? 'Kudos given' : 'Give kudos',
                  active: post.hasGivenKudos,
                  onTap: onToggleKudos,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionPillButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: post.allowComments ? 'Comment' : 'Disabled',
                  enabled: post.allowComments,
                  onTap: post.allowComments ? onTapComment : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostAuthorAvatar extends StatelessWidget {
  final Club club;
  final ClubPost post;

  const _PostAuthorAvatar({required this.club, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.authorRole == PostAuthorRole.club) {
      return ClubAvatar(club: club, size: 42);
    }

    final initial = post.authorName.trim().isEmpty
        ? 'A'
        : post.authorName.trim().substring(0, 1).toUpperCase();

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Styles.selectedFill,
        border: Border.all(color: Styles.teal, width: 1.5),
      ),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Styles.teal,
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final PostTag tag;

  const _TagBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Styles.teal.withAlpha(28),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tag.icon, size: 13, color: Styles.teal),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Styles.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool enabled;
  final VoidCallback? onTap;

  const _ActionPillButton({
    required this.icon,
    required this.label,
    this.active = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = !enabled
        ? Styles.surfaceHighlight.withAlpha(90)
        : (active ? Styles.accent : Colors.white);

    return Material(
      color: active ? Styles.accent.withAlpha(30) : Styles.fieldFill,
      borderRadius: BorderRadius.circular(Radii.chip),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(Radii.chip),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

