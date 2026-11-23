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
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: Styles.cardDecoration(radius: Radii.field),
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Styles.surfaceHighlight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.timeline_rounded,
                    color: Styles.primaryLight,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rekam aktivitas pertama Anda',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Styles.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Saat merekam aktivitas, Anda akan melihatnya di sini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                  ),
                  onPressed: onAddFirstActivity,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (activityCount > 0)
            Container(
              decoration: Styles.cardDecoration(
                radius: Radii.field,
                highlighted: true,
              ),
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Styles.success.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_run,
                      color: Styles.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lari Pagi Jakarta ($activityCount Sesi)',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Total Jarak: ${activityCount * 3} km • Waktu: ${activityCount * 20}m',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Styles.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Styles.success,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}