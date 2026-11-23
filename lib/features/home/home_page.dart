import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_streak_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/streak_chart_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/stride_wordmark.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _badges = [
    {'title': 'Basic Runner', 'image': 'asset/images/basic_runner.png'},
    {'title': 'Rookie Runner', 'image': 'asset/images/rookie_runner.png'},
    {'title': 'Master Runner', 'image': 'asset/images/master_runner.png'},
    {'title': 'Grand Master Runner', 'image': 'asset/images/grand_master_runner.png'},
    {'title': 'Elite Global Runeer', 'image': 'asset/images/elite_global_runner.png'},
  ];

  static const _dailyStats = [
    {'title': 'Heart Rate', 'image': 'asset/images/heart rate.png'},
    {'title': 'Pace Speed', 'image': 'asset/images/pace.png'},
    {'title': 'Average Time', 'image': 'asset/images/time.png'},
    {'title': 'Calories Burn', 'image': 'asset/images/calories.png'},
    {'title': 'Steps Taken', 'image': 'asset/images/steps.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppHeader(
        titleWidget: const StrideWordmark(),
        actions: [
          AddMenuButton(onSelected: (action) => openAddAction(context, action)),
          HeaderIconButton(
            icon: Icons.forum_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FriendsPage()),
            ),
          ),
          HeaderIconButton(
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          Consumer(
            builder: (context, ref, _) => HeaderIconButton(
              icon: Icons.notifications_none,
              badgeCount: ref.watch(unreadCountProvider),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeStreakWidget(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StreakChartWidget(),
            ),
            _buildDailyStatsSection(context),
            _buildBadgesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const _SectionHeader(
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

  Widget _buildBadgesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const _SectionHeader(
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
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
