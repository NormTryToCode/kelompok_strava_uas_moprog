import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:provider/provider.dart';
import '../../models/gear_bag.dart';
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
        decoration: BoxDecoration(
          color: Styles.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Styles.inactive),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Analitik ${stats.sportLabel}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Status: ${stats.athleteLevelBadge}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Styles.active,
                      ),
                    ),
                  ],
                ),
                Consumer<GearBagModel>(
                  builder: (context, bag, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.background,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Styles.accent),
                      ),
                      child: Text(
                        '${bag.items.length} Gear Aktif',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Styles.accent,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Tahunan (${stats.yearlyDistanceText} / ${stats.annualTargetDistance.withThousands} ${stats.distanceUnit})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Styles.tabInactive,
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Styles.accent,
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
                    color: Styles.background,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: barWidth,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: Palette.primaryGradient,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Styles.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Estimasi Kalori: ${stats.estimatedCaloriesBurned.withThousands} kcal',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove, size: 15),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: onReset,
                      icon: const Icon(Icons.exposure_zero, size: 15),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filled(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add, size: 15),
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