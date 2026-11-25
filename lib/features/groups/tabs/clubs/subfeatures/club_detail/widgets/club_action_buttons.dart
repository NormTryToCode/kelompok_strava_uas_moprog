import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubActionButtons extends StatelessWidget {
  final bool canManage;
  final VoidCallback onInviteTap;
  final VoidCallback onEditDetailsTap;
  final VoidCallback onShareTap;
  final VoidCallback onEventsTap;
  final VoidCallback onOverviewTap;
  final VoidCallback onPostsTap;

  const ClubActionButtons({
    super.key,
    required this.onInviteTap,
    required this.onEditDetailsTap,
    required this.onShareTap,
    required this.onEventsTap,
    required this.onOverviewTap,
    required this.onPostsTap,
    this.canManage = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.person_add_alt, 'Invite', onInviteTap),
      if (canManage)
        (Icons.edit_outlined, 'Edit details', onEditDetailsTap),
      (Icons.share_outlined, 'Share', onShareTap),
      (Icons.event_available_outlined, 'Events', onEventsTap),
      (Icons.info_outline, 'Overview', onOverviewTap),
      (Icons.article_outlined, 'Posts', onPostsTap),
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
                    side: BorderSide(color: Styles.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: item.$3,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(item.$1, size: 22, color: Styles.textPrimary),
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
                    color: Styles.textSecondary,
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