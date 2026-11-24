import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class BestEffortsWidget extends StatelessWidget {
  final int viewMode;
  final int runSessions;
  final VoidCallback onOpenFeedback;

  const BestEffortsWidget({
    super.key,
    required this.viewMode,
    required this.runSessions,
    required this.onOpenFeedback,
  });

  @override
  Widget build(BuildContext context) {
    if (viewMode == 1) {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: Styles.cardDecoration(radius: Radii.field),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usaha Terbaik',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: Styles.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: Styles.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.workspace_premium,
                                color: Styles.canvas,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RP 5K',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: Styles.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Nov 3, 2026',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Styles.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '26:54',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Styles.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Styles.surfaceElevated,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Styles.borderStrong),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.military_tech,
                                color: Styles.textSecondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Waktu 5K tercepat ke-2',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: Styles.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Nov 3, 2025',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Styles.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '30:12',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: Styles.cardDecoration(radius: Radii.field),
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Target',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.directions_run,
                          color: Styles.success,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Target Berlari Mingguan',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$runSessions/4 lari',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Styles.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: Styles.cardDecoration(radius: Radii.field),
                    padding: const EdgeInsets.all(14.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usaha Relatif',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '89',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Styles.primaryLight,
                          ),
                        ),
                        Text(
                          'Nov 2 - Nov 8, 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: Styles.textSecondary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '22',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Styles.secondary,
                          ),
                        ),
                        Text(
                          'Okt 26 - Nov 1, 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: Styles.cardDecoration(radius: Radii.field),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan Latihan',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nov 2 - Nov 8, 2026',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Styles.textSecondary,
                      ),
                    ),
                    Text(
                      '10,9 km',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('S', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('S', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('R', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('K', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('J', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('S', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                    Text('M', style: TextStyle(fontSize: 13, color: Styles.textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.circle, size: 12, color: Styles.success),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Styles.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: const Text(
                        '3,7 km',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Styles.canvas,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Styles.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: const Text(
                        '6,4 km',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Styles.canvas,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: Styles.buttonDecoration(radius: Radii.button),
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: const Center(
              child: Text(
                'Mulai Percobaan Gratis',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Styles.canvas,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: Styles.cardDecoration(radius: Radii.field),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Tertarik berbagi masukan Anda?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Styles.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.surfaceHighlight,
                    foregroundColor: Styles.primaryLight,
                    side: const BorderSide(color: Styles.primaryLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                  ),
                  onPressed: onOpenFeedback,
                  child: const Text(
                    'Beri Masukan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}