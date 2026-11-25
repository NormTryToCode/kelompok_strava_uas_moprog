import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_section_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  static const _badges = [
    {
      'title': 'Basic Runner',
      'image': 'asset/images/basic_runner.png',
      'description': 'Complete your very first tracked run on Stride.',
      'progressText': '1 / 1 run',
      'progress': '1.0',
    },
    {
      'title': 'Rookie Runner',
      'image': 'asset/images/rookie_runner.png',
      'description': 'Reach a total distance of 25 km across all recorded runs.',
      'progressText': '18.5 / 25 km',
      'progress': '0.74',
    },
    {
      'title': 'Master Runner',
      'image': 'asset/images/master_runner.png',
      'description': 'Reach a total distance of 100 km and maintain a 7-day streak.',
      'progressText': '42.0 / 100 km',
      'progress': '0.42',
    },
    {
      'title': 'Grand Master Runner',
      'image': 'asset/images/grand_master_runner.png',
      'description': 'Log 250 km total running distance with an average pace under 5\'30" /km.',
      'progressText': '42.0 / 250 km',
      'progress': '0.17',
    },
    {
      'title': 'Elite Global Runner',
      'image': 'asset/images/elite_global_runner.png',
      'description': 'Complete 500 km total distance to join the top global runners.',
      'progressText': '42.0 / 500 km',
      'progress': '0.08',
    },
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
            onTap: () => _showBadgeDetailModal(context, badge),
          ),
        ),
      ],
    );
  }

  void _showBadgeDetailModal(BuildContext context, Map<String, String> badge) {
    final progress = (double.tryParse(badge['progress'] ?? '0') ?? 0.0).clamp(0.0, 1.0);
    final isUnlocked = progress >= 1.0;
    final percent = (progress * 100).round();

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
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              badge['image']!,
              height: 115,
              width: 115,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 14),
            Text(
              badge['title']!,
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
                color: (isUnlocked ? Styles.success : Styles.primary)
                    .withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (isUnlocked ? Styles.success : Styles.primary)
                      .withValues(alpha: 0.45),
                ),
              ),
              child: Text(
                isUnlocked ? 'Unlocked' : 'In Progress • $percent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked ? Styles.success : Styles.primaryLight,
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
                border: Border.all(color: Styles.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to Get',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Styles.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    badge['description']!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Styles.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Styles.textSecondary,
                        ),
                      ),
                      Text(
                        badge['progressText']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isUnlocked ? Styles.success : Styles.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Styles.surfaceHighlight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isUnlocked ? Styles.success : Styles.primary,
                      ),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Styles.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Styles.surfaceHighlight.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.borderStrong),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: Styles.primaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
