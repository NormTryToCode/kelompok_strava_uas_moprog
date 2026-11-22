import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubActionButtons extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onInviteTap;
  final VoidCallback? onEditDetailsTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onEventsTap;
  final VoidCallback? onOverviewTap;
  final VoidCallback? onPostsTap;

  const ClubActionButtons({
    super.key,
    required this.onTap,
    this.onInviteTap,
    this.onEditDetailsTap,
    this.onShareTap,
    this.onEventsTap,
    this.onOverviewTap,
    this.onPostsTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person_add_alt, 'Invite', onInviteTap ?? onTap),
      (Icons.edit_outlined, 'Edit details', onEditDetailsTap ?? onTap),
      (Icons.share_outlined, 'Share', onShareTap ?? onTap),
      (Icons.event_available_outlined, 'Events', onEventsTap ?? onTap),
      (Icons.info_outline, 'Overview', onOverviewTap ?? onTap),
      (Icons.article_outlined, 'Posts', onPostsTap ?? onTap),
      (Icons.insights_outlined, 'Insights', onTap),
      (Icons.monitor_heart_outlined, 'Activities', onTap),
      (Icons.leaderboard_outlined, 'Stats', onTap),
    ];

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final item = items[index];
          return SizedBox(
            width: 68,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Styles.surface,
                  shape: const CircleBorder(
                    side: BorderSide(color: Palette.cardBorder),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: item.$3,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(item.$1, size: 22, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Styles.tabInactive,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}