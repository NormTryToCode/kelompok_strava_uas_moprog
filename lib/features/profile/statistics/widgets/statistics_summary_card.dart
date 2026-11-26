import 'dart:math' as math;
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
    final bool goalSurpassed = stats.remainingTargetDistance <= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 14.0),
      child: Container(
        decoration: Styles.cardDecoration(
          radius: Radii.card,
          highlighted: true,
          withGlow: true,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -65,
              right: -55,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: Styles.radialGlow(
                    color: Styles.primary,
                    intensity: 0.30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
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
                              '${stats.sportLabel} Telemetry',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: stats.allTimeTotalSessions > 0
                                      ? Styles.success
                                      : Styles.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    stats.athleteLevelBadge,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: stats.allTimeTotalSessions > 0
                                        ? Styles.success
                                        : Styles.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
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
                              vertical: 5.5,
                            ),
                            decoration: BoxDecoration(
                              color: Styles.canvas.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Styles.primaryLight.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bolt_rounded,
                                  size: 13,
                                  color: Styles.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$activeGearCount Active Gear',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: Styles.radialGlow(
                                  color: goalSurpassed
                                    ? Styles.success
                                    : Styles.primary,
                                  intensity: 0.28,
                                ),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(122, 122),
                              painter: _AnnualTargetGaugePainter(
                                progress: stats.annualProgressRatio,
                                completed: goalSurpassed,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$percent%',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  goalSurpassed ? 'TARGET HIT' : 'ANNUAL GOAL',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: goalSurpassed
                                      ? Styles.success
                                      : Styles.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _GaugeStatPill(
                              icon: Icons.route_rounded,
                              label: 'Season Volume',
                              value:
                                '${stats.yearlyDistanceText} / ${stats.annualTargetDistance.withThousands} ${stats.distanceUnit}',
                            ),
                            const SizedBox(height: 8),
                            _GaugeStatPill(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Energy Burn',
                              value:
                                '${stats.estimatedCaloriesBurned.withThousands} kcal',
                            ),
                            const SizedBox(height: 8),
                            _GaugeStatPill(
                              icon: goalSurpassed
                                ? Icons.verified_rounded
                                : Icons.flag_outlined,
                              label: 'Target Status',
                              value: stats.remainingTargetText,
                              valueColor: goalSurpassed
                                ? Styles.success
                                : Styles.primaryLight,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.canvas.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(Radii.field),
                      border: Border.all(color: Styles.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Weekly Session Simulator',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Styles.textPrimary,
                                ),
                              ),
                              Text(
                                'Adjust ${stats.sportLabel.toLowerCase()} volume live',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Styles.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Styles.surfaceElevated,
                                foregroundColor: Styles.textPrimary,
                                minimumSize: const Size(34, 34),
                              ),
                              onPressed: onDecrement,
                              icon: const Icon(Icons.remove, size: 16),
                            ),
                            const SizedBox(width: 6),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Styles.surfaceElevated,
                                foregroundColor: Styles.textPrimary,
                                minimumSize: const Size(34, 34),
                              ),
                              onPressed: onReset,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                            ),
                            const SizedBox(width: 6),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Styles.primary,
                                foregroundColor: Styles.textPrimary,
                                minimumSize: const Size(34, 34),
                              ),
                              onPressed: onIncrement,
                              icon: const Icon(Icons.add, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugeStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _GaugeStatPill({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Styles.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: valueColor ?? Styles.primaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Styles.textSecondary,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? Styles.textPrimary,
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

class _AnnualTargetGaugePainter extends CustomPainter {
  final double progress;
  final bool completed;

  const _AnnualTargetGaugePainter({
    required this.progress,
    required this.completed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - 10;

    final Paint trackPaint = Paint()
      ..color = Styles.borderStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final Paint tickPaint = Paint()
      ..color = (completed ? Styles.success : Styles.primaryLight)
        .withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (int i = 0; i < 32; i++) {
      final double angle = (i * 2 * math.pi) / 32;
      final bool isMajor = i % 8 == 0;
      final double startR = radius + 6;
      final double endR = radius + (isMajor ? 11 : 8.5);
      canvas.drawLine(
        Offset(
          center.dx + startR * math.cos(angle),
          center.dy + startR * math.sin(angle),
        ),
        Offset(
          center.dx + endR * math.cos(angle),
          center.dy + endR * math.sin(angle),
        ),
        tickPaint,
      );
    }

    if (progress <= 0) return;

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    final Paint arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: completed
          ? const [Styles.primary, Styles.success, Styles.primaryLight]
          : const [Styles.primaryDark, Styles.primary, Styles.primaryLight],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnnualTargetGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
      oldDelegate.completed != completed;
  }
}