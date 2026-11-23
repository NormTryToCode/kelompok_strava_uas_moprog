import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../gear/providers/athlete_gear_provider.dart';
import '../models/sport_statistics_data.dart';

class StatisticsSummaryCard extends StatelessWidget {
  final SportStatisticsData stats;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onIncrement;

  const StatisticsSummaryCard({
    super.key,
    required this.stats,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final int percent = (stats.annualProgressRatio * 100).round();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: Styles.cardDecoration(
          radius: Radii.card,
          highlighted: true,
          withGlow: true,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analitik ${stats.sportLabel}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Status: ${stats.athleteLevelBadge}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Styles.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, child) {
                    final int activeGearCount =
                      ref.watch(activeGearCountProvider);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.canvas.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Styles.primaryLight),
                      ),
                      child: Text(
                        '$activeGearCount Gear Aktif',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Styles.primaryLight,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Target Tahunan (${stats.yearlyDistanceText} / ${stats.annualTargetDistance.withThousands} ${stats.distanceUnit})',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Styles.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Styles.primaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final double barWidth =
                  constraints.maxWidth * stats.annualProgressRatio;
                return Container(
                  width: constraints.maxWidth,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Styles.canvas,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: barWidth,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: Styles.primaryGradient,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: Styles.glow(intensity: 0.35, blur: 10),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Styles.canvas.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(Radii.chip),
                border: Border.all(color: Styles.borderStrong),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Styles.primaryLight,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Estimasi Kalori: ${stats.estimatedCaloriesBurned.withThousands} kcal',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Atur Sesi Mingguan',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Styles.textSecondary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.surfaceElevated,
                        foregroundColor: Styles.textPrimary,
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.surfaceElevated,
                        foregroundColor: Styles.textPrimary,
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: onReset,
                      icon: const Icon(Icons.exposure_zero, size: 16),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.primary,
                        foregroundColor: Styles.textPrimary,
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}