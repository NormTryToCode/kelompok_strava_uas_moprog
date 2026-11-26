import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_section_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';

class DailyStatsSection extends StatelessWidget {
  const DailyStatsSection({super.key});

  static const _dailyStats = [
    {
      'title': 'Heart Rate',
      'image': 'asset/images/heart rate.png',
      'today': '142 bpm',
      'average': '138 bpm',
      'best': '168 bpm',
    },
    {
      'title': 'Pace Speed',
      'image': 'asset/images/pace.png',
      'today': '5\'12" /km',
      'average': '5\'24" /km',
      'best': '4\'48" /km',
    },
    {
      'title': 'Average Time',
      'image': 'asset/images/time.png',
      'today': '42 mins',
      'average': '38 mins',
      'best': '1h 15m',
    },
    {
      'title': 'Calories Burn',
      'image': 'asset/images/calories.png',
      'today': '340 kcal',
      'average': '410 kcal',
      'best': '780 kcal',
    },
    {
      'title': 'Steps Taken',
      'image': 'asset/images/steps.png',
      'today': '6,840',
      'average': '8,120',
      'best': '14,500',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const HomeSectionHeader(
          title: 'Daily Stats',
          subtitle: "Today's highlights",
        ),
        HorizontalCarousel.cards(
          items: _dailyStats,
          height: 205,
          viewportFraction: 0.62,
          bordered: true,
          cardBuilder: (context, stat) => _StatCard(
            title: stat['title']!,
            value: stat['today']!,
            image: stat['image']!,
            onTap: () => _showStatDetailModal(context, stat),
          ),
        ),
      ],
    );
  }

  void _showStatDetailModal(BuildContext context, Map<String, String> stat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Styles.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              stat['image']!,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 14),
            Text(
              stat['title']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Styles.primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Styles.primary.withValues(alpha: 0.45),
                ),
              ),
              child: const Text(
                'Today\'s Summary',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Styles.primaryLight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Styles.borderStrong),
              ),
              child: Column(
                children: [
                  const Text(
                    'Recorded Today',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Styles.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['today']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Styles.primaryLight,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Styles.divider),
                  ),
                  _DetailRow(label: '7-Day Average', value: stat['average']!),
                  _DetailRow(label: 'Personal Best', value: stat['best']!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String image;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: Styles.radialGlow(
                              color: Styles.primary,
                              intensity: 0.24,
                            ),
                          ),
                        ),
                        Image.asset(image, fit: BoxFit.contain),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Styles.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Styles.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 6,
            right: 6,
            child: Icon(
              Icons.north_east_rounded,
              size: 14,
              color: Styles.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Styles.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Styles.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
