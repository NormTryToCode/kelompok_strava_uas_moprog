import 'dart:math' as math;
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
    final int targetKm = 30;
    final int remainingKm = (targetKm - distanceKm).clamp(0, targetKm);
    final int durationMinutes = runSessions * 20;
    final int elevationMeters = runSessions * 12;
    final double progress = (runSessions / 10).clamp(0.0, 1.0);

    const List<double> historicHeights = [
      0.28, 0.42, 0.35, 0.56, 0.48, 0.65,
      0.40, 0.72, 0.52, 0.62, 0.50,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: Column(
        children: [
          Container(
            decoration: Styles.cardDecoration(
              radius: Radii.card,
              highlighted: true,
              withGlow: true,
            ),
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Momentum',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Kilometers Logged',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.canvas.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: runSessions >= 10
                            ? Styles.success
                            : Styles.borderStrong,
                        ),
                      ),
                      child: Text(
                        '$runSessions / 10 runs',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: runSessions >= 10
                            ? Styles.success
                            : Styles.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    SizedBox(
                      width: 124,
                      height: 124,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 124,
                            height: 124,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: Styles.radialGlow(
                                color: Styles.primary,
                                intensity: 0.28,
                              ),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(116, 116),
                            painter: _MomentumRingPainter(progress: progress),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$distanceKm km',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Styles.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                remainingKm == 0
                                  ? 'Goal Hit!'
                                  : '$remainingKm km left',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: remainingKm == 0
                                    ? Styles.success
                                    : Styles.textSecondary,
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
                          _TelemetryTile(
                            icon: Icons.timer_outlined,
                            label: 'Active Time',
                            value: '${durationMinutes}m',
                          ),
                          const SizedBox(height: 10),
                          _TelemetryTile(
                            icon: Icons.terrain_rounded,
                            label: 'Elevation Gain',
                            value: '$elevationMeters m',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.canvas.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(Radii.field),
                    border: Border.all(color: Styles.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Log Quick Session',
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
                              disabledBackgroundColor: Styles.surfaceElevated,
                              disabledForegroundColor: Styles.textMuted,
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
                if (runSessions >= 10)
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Styles.success,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Weekly Peak Target (10 Sessions) Achieved!',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Styles.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: Styles.cardDecoration(radius: Radii.card),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '12-Week Rhythm',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    Text(
                      '$distanceKm km this week',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 68,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...historicHeights.map(
                        (ratio) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              height: 58 * ratio,
                              decoration: BoxDecoration(
                                color: Styles.surfaceHighlight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            height: math.max(12, 58 * (0.2 + progress * 0.8)),
                            decoration: BoxDecoration(
                              gradient: Styles.linearGradient(
                                colors: const [
                                  Styles.primaryLight,
                                  Styles.primary,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: Styles.glow(intensity: 0.4, blur: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SEP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Styles.textSecondary,
                      ),
                    ),
                    Text(
                      'OCT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Styles.textSecondary,
                      ),
                    ),
                    Text(
                      'NOV',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TelemetryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TelemetryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(color: Styles.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Styles.primaryLight),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Styles.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
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

class _MomentumRingPainter extends CustomPainter {
  final double progress;

  const _MomentumRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - 8;

    final Paint trackPaint = Paint()
      ..color = Styles.borderStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final Paint tickPaint = Paint()
      ..color = Styles.primaryLight.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 24; i++) {
      final double angle = (i * 2 * math.pi) / 24;
      final Offset p1 = Offset(
        center.dx + (radius + 6) * math.cos(angle),
        center.dy + (radius + 6) * math.sin(angle),
      );
      final Offset p2 = Offset(
        center.dx + (radius + 9) * math.cos(angle),
        center.dy + (radius + 9) * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    if (progress <= 0) return;

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    final Paint arcPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [Styles.primaryDark, Styles.primary, Styles.primaryLight],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
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
  bool shouldRepaint(covariant _MomentumRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}