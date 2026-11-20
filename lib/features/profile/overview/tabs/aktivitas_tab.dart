import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class AktivitasTab extends StatelessWidget {
  final int activityCount;
  final VoidCallback onAddFirstActivity;

  const AktivitasTab({
    super.key,
    required this.activityCount,
    required this.onAddFirstActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: Styles.tabActive,
                      size: 28,
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rekam aktivitas pertama Anda",
                          style: TextStyle(
                            fontSize: 15,
                            color: Styles.tabActive,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Saat merekam aktivitas, Anda akan\nmelihatnya di sini.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Styles.tabInactive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: onAddFirstActivity,
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Styles.tabActive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (activityCount > 0)
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_run,
                        color: Styles.active,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lari Pagi Jakarta ($activityCount Sesi)",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Styles.tabActive,
                            ),
                          ),
                          Text(
                            "Total Jarak: ${activityCount * 3} km • Waktu: ${activityCount * 20}m",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Styles.active,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Styles.active,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}