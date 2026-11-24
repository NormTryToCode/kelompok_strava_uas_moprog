import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_section_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  static const _badges = [
    {'title': 'Basic Runner', 'image': 'asset/images/basic_runner.png'},
    {'title': 'Rookie Runner', 'image': 'asset/images/rookie_runner.png'},
    {'title': 'Master Runner', 'image': 'asset/images/master_runner.png'},
    {'title': 'Grand Master Runner', 'image': 'asset/images/grand_master_runner.png'},
    {'title': 'Elite Global Runeer', 'image': 'asset/images/elite_global_runner.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const HomeSectionHeader(
          title: 'Badges',
          subtitle: 'Earn the badges',
        ),
        HorizontalCarousel.cards(
          items: _badges,
          bordered: true,
          cardBuilder: (context, badge) => _BadgeCard(
            title: badge['title']!,
            image: badge['image']!,
            onTap: () => _showBadgeDetailModal(
              context,
              badge['title']!,
              badge['image']!,
            ),
          ),
        ),
      ],
    );
  }

  void _showBadgeDetailModal(BuildContext context, String title, String image) {
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
            const SizedBox(height: 24),
            Image.asset(image, height: 110, width: 110, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Achievement Milestone',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _badgeDescription(title),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _badgeDescription(String title) {
    switch (title) {
      case 'Basic Runner':
        return 'Complete your very first tracked run on Stride.';
      case 'Rookie Runner':
        return 'Reach a total distance of 25 km across all recorded runs.';
      case 'Master Runner':
        return 'Reach a total distance of 100 km and maintain a 7-day streak.';
      case 'Grand Master Runner':
        return 'Log 250 km total running distance with an average pace under 5\'30" /km.';
      default:
        return 'Complete 500 km total distance to join the top global runners.';
    }
  }
}

class _BadgeCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _BadgeCard({
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
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
