import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Styles.accent,
              child: Text(
                'STRAVA',
                style: TextStyle(
                  color: Styles.tabActive,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Styles.tabActive,
                      fontSize: 17,
                      fontWeight:
                          item.isRead ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: const TextStyle(
                      color: Styles.tabActive,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.createdAt.timeAgo(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 6),
                child: Icon(Icons.circle, size: 10, color: Styles.accent),
              ),
          ],
        ),
      ),
    );
  }
}