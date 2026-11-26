import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubActionButtons extends StatelessWidget {
  final bool canManage;
  final bool showPendingRequests;
  final int pendingRequestCount;
  final VoidCallback? onPendingRequestsTap;
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
    this.showPendingRequests = false,
    this.pendingRequestCount = 0,
    this.onPendingRequestsTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback, int)>[
      if (canManage && showPendingRequests && onPendingRequestsTap != null)
        (
          Icons.how_to_reg_outlined,
          'Requests',
          onPendingRequestsTap!,
          pendingRequestCount,
        ),
      (Icons.person_add_alt, 'Invite', onInviteTap, 0),
      if (canManage)
        (Icons.edit_outlined, 'Edit details', onEditDetailsTap, 0),
      (Icons.share_outlined, 'Share', onShareTap, 0),
      (Icons.event_available_outlined, 'Events', onEventsTap, 0),
      (Icons.info_outline, 'Overview', onOverviewTap, 0),
      (Icons.article_outlined, 'Posts', onPostsTap, 0),
    ];

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final item = items[index];
          final badgeCount = item.$4;

          return SizedBox(
            width: 68,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
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
                          child: Icon(
                            item.$1,
                            size: 22,
                            color: Styles.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Styles.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Styles.canvas,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            badgeCount > 99 ? '99+' : '$badgeCount',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
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