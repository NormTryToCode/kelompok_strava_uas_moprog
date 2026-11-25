import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
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
      final double weeklyGoalRatio = (runSessions / 4).clamp(0.0, 1.0);
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: Styles.cardDecoration(
                radius: Radii.card,
                withGlow: true,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Peak Records',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      Text(
                        'ALL-TIME',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Styles.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _RecordRow(
                    icon: Icons.workspace_premium_rounded,
                    title: '5K Personal Best',
                    subtitle: 'Nov 3, 2026  •  5:22 /km',
                    timeText: '26:54',
                    isPrimary: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Styles.divider),
                  ),
                  const _RecordRow(
                    icon: Icons.military_tech_rounded,
                    title: '2nd Fastest 5K Split',
                    subtitle: 'Nov 3, 2025  •  6:02 /km',
                    timeText: '30:12',
                    isPrimary: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: Styles.cardDecoration(radius: Radii.card),
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weekly Goal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            Icon(
                              Icons.flag_rounded,
                              size: 18,
                              color: weeklyGoalRatio >= 1.0
                                ? Styles.success
                                : Styles.primaryLight,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$runSessions / 4',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Styles.success,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Sessions target',
                          style: TextStyle(
                            fontSize: 12,
                            color: Styles.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: weeklyGoalRatio,
                            minHeight: 6,
                            backgroundColor: Styles.canvas,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Styles.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: Styles.cardDecoration(radius: Radii.card),
                    padding: const EdgeInsets.all(15.0),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Effort Index',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Styles.textPrimary,
                              ),
                            ),
                            Icon(
                              Icons.local_fire_department_rounded,
                              size: 18,
                              color: Styles.primaryLight,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '89',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Styles.primaryLight,
                          ),
                        ),
                        Text(
                          'This week  •  Peak',
                          style: TextStyle(
                            fontSize: 12,
                            color: Styles.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Prior week: 22 pts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Styles.secondary,
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

    const List<({String day, double height, String tag, bool highlight})>
        weekBars = [
      (day: 'M', height: 0.16, tag: '', highlight: false),
      (day: 'T', height: 0.36, tag: '1.8k', highlight: false),
      (day: 'W', height: 0.18, tag: '', highlight: false),
      (day: 'T', height: 0.62, tag: '3.7k', highlight: true),
      (day: 'F', height: 0.96, tag: '6.4k', highlight: true),
      (day: 'S', height: 0.25, tag: '', highlight: false),
      (day: 'S', height: 0.42, tag: '2.1k', highlight: false),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: Styles.cardDecoration(
              radius: Radii.card,
              withGlow: true,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '7-Day Activity Pulse',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Nov 2 – Nov 8, 2026',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '10.9 km',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 112,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: weekBars.map((item) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (item.tag.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  item.tag,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: item.highlight
                                      ? Styles.primaryLight
                                      : Styles.textSecondary,
                                  ),
                                ),
                              ),
                            Container(
                              width: 18,
                              height: 66 * item.height,
                              decoration: BoxDecoration(
                                gradient: item.highlight
                                  ? Styles.linearGradient(
                                    colors: const [
                                        Styles.primaryLight,
                                        Styles.primary,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                                color: item.highlight
                                  ? null
                                  : Styles.surfaceHighlight,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: item.highlight
                                  ? Styles.glow(intensity: 0.35, blur: 10)
                                  : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: item.highlight
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                                color: item.highlight
                                  ? Styles.textPrimary
                                  : Styles.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: Styles.cardDecoration(
              radius: Radii.card,
              highlighted: true,
            ),
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: Styles.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
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
                        '${AppBrand.name} Pro Insights',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Unlock AI pace splits & deep recovery telemetry.',
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
          const SizedBox(height: 12),
          Container(
            decoration: Styles.cardDecoration(radius: Radii.field),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help Shape ${AppBrand.name}',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Styles.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Share thoughts on your athlete dashboard.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
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
                    'Feedback',
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

class _RecordRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timeText;
  final bool isPrimary;

  const _RecordRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: isPrimary ? Styles.primaryGradient : null,
            color: isPrimary ? null : Styles.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: isPrimary ? null : Border.all(color: Styles.borderStrong),
          ),
          padding: const EdgeInsets.all(9.0),
          child: Icon(
            icon,
            color: isPrimary ? Styles.canvas : Styles.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          timeText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isPrimary ? Styles.primaryLight : Styles.textSecondary,
          ),
        ),
      ],
    );
  }
}