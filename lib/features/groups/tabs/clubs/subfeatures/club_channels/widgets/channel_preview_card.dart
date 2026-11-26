import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ChannelPreviewCard extends StatelessWidget {
  final String name;
  final String description;
  final ChannelCategory category;
  final ChannelMembership membership;
  final ChannelPostPermission postPermission;

  const ChannelPreviewCard({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.membership,
    required this.postPermission,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().isEmpty ? 'Untitled channel' : name.trim();
    final displayDesc = description.trim().isEmpty
        ? 'Live preview of how your channel appears to club members.'
        : description.trim();
    final accentColor = category == ChannelCategory.announcement
        ? Styles.accent
        : Styles.teal;

    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBubble(category.icon, size: 46, color: accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            displayDesc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.35,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              InfoChip(icon: membership.icon, label: membership.title),
              InfoChip(icon: postPermission.icon, label: postPermission.title),
            ],
          ),
        ],
      ),
    );
  }
}

