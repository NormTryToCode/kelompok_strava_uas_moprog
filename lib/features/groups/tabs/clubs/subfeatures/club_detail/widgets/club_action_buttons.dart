import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubActionButtons extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onEditDetailsTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onEventsTap;
  final VoidCallback? onOverviewTap;
  final VoidCallback? onPostsTap;

  const ClubActionButtons({
    super.key,
    required this.onTap,
    this.onEditDetailsTap,
    this.onShareTap,
    this.onEventsTap,
    this.onOverviewTap,
    this.onPostsTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person_add_alt, 'Invite', onTap),
      (Icons.edit_outlined, 'Edit details', onEditDetailsTap ?? onTap),
      (Icons.share_outlined, 'Share', onShareTap ?? onTap),
      (Icons.insights_outlined, 'Insights', onTap),
      (Icons.event_available_outlined, 'Events', onEventsTap ?? onTap),
      (Icons.info_outline, 'Overview', onOverviewTap ?? onTap),
      (Icons.monitor_heart_outlined, 'Activities', onTap),
      (Icons.leaderboard_outlined, 'Stats', onTap),
      (Icons.article_outlined, 'Posts', onPostsTap ?? onTap),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        for (final item in items)
          SoftCard(
            padding: const EdgeInsets.all(8),
            radius: 18,
            onTap: item.$3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconBubble(item.$1, size: 40),
                const SizedBox(height: 8),
                Text(
                  item.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}