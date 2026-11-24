import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_section_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';

class DailyStatsSection extends StatelessWidget {
  const DailyStatsSection({super.key});

  static const _dailyStats = [
    {'title': 'Heart Rate', 'image': 'asset/images/heart rate.png'},
    {'title': 'Pace Speed', 'image': 'asset/images/pace.png'},
    {'title': 'Average Time', 'image': 'asset/images/time.png'},
    {'title': 'Calories Burn', 'image': 'asset/images/calories.png'},
    {'title': 'Steps Taken', 'image': 'asset/images/steps.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const HomeSectionHeader(
          title: 'Daily Stats',
          subtitle: 'Todays Stats',
        ),
        HorizontalCarousel.cards(
          items: _dailyStats,
          bordered: true,
          cardBuilder: (context, stat) => _StatCard(
            title: stat['title']!,
            image: stat['image']!,
            onTap: () => _showStatDetailModal(
              context,
              stat['title']!,
              stat['image']!,
            ),
          ),
        ),
      ],
    );
  }

  void _showStatDetailModal(BuildContext context, String title, String image) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
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
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset(image, height: 32, width: 32),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '7-Day Activity Breakdown',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DetailRow(label: 'Today', value: _statPreviewValue(title, 0)),
            _DetailRow(label: '7-Day Average', value: _statPreviewValue(title, 1)),
            _DetailRow(label: 'Personal Best', value: _statPreviewValue(title, 2)),
          ],
        ),
      ),
    );
  }

  String _statPreviewValue(String title, int index) {
    switch (title) {
      case 'Heart Rate':
        return ['142 bpm', '138 bpm', '168 bpm'][index];
      case 'Pace Speed':
        return ['5\'12" /km', '5\'24" /km', '4\'48" /km'][index];
      case 'Average Time':
        return ['42 mins', '38 mins', '1h 15m'][index];
      case 'Calories Burn':
        return ['340 kcal', '410 kcal', '780 kcal'][index];
      case 'Steps Taken':
        return ['6,840', '8,120', '14,500'][index];
      default:
        return '-';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(image, height: 32, width: 32, fit: BoxFit.contain),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ],
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
