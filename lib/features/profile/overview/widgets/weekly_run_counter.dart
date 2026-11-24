import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class WeeklyRunCounter extends StatelessWidget {
  final int runSessions;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback? onIncrement;

  const WeeklyRunCounter({
    super.key,
    required this.runSessions,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final int distanceKm = runSessions * 3;
    final int durationMinutes = runSessions * 20;
    final int elevationMeters = runSessions * 12;

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        decoration: Styles.cardDecoration(radius: Radii.field, withGlow: true),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minggu ini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Styles.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.surfaceHighlight,
                        foregroundColor: Styles.textPrimary,
                      ),
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.surfaceHighlight,
                        foregroundColor: Styles.textPrimary,
                      ),
                      onPressed: onReset,
                      icon: const Icon(Icons.exposure_zero, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.primary,
                        foregroundColor: Styles.textPrimary,
                        disabledBackgroundColor: Styles.surfaceElevated,
                        disabledForegroundColor: Styles.textMuted,
                      ),
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jarak',
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$distanceKm km',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waktu',
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${durationMinutes}m',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kenaikan Elev',
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$elevationMeters m',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '12 Minggu Terakhir',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Styles.borderStrong,
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Styles.borderStrong,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(
                            11,
                            (_) => const Icon(
                              Icons.circle_outlined,
                              size: 11,
                              color: Styles.primaryLight,
                            ),
                          ),
                          const Icon(
                            Icons.circle,
                            size: 14,
                            color: Styles.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SEP',
                            style: TextStyle(
                              fontSize: 11,
                              color: Styles.textSecondary,
                            ),
                          ),
                          Text(
                            'OKT',
                            style: TextStyle(
                              fontSize: 11,
                              color: Styles.textSecondary,
                            ),
                          ),
                          Text(
                            'NOV',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '6 km',
                      style: TextStyle(
                        fontSize: 11,
                        color: Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '3 km',
                      style: TextStyle(
                        fontSize: 11,
                        color: Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '$distanceKm km',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (runSessions >= 10)
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Target Maksimal (10 Sesi) Minggu Ini Tercapai!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Styles.success,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}