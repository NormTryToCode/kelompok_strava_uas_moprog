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
            _buildDailyStatsSection(),
            _buildBadgesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatsSection() {
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
          cardBuilder: (context, stat) => _StatCard(stat: stat),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
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
          cardBuilder: (context, badge) => _BadgeCard(badge: badge),
        ),
      ],
    );
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
  final Map<String, String> stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(stat['image']!, height: 32, width: 32, fit: BoxFit.contain),
              Icon(
                Icons.arrow_outward_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ],
          ),
          Text(
            stat['title']!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final Map<String, String> badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(badge['image']!, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(
            badge['title']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
