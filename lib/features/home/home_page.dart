import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_streak_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/horizontal_carousel.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/stride_wordmark.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> _badges = [
    {'title': 'Basic Runner', 'image': 'asset/images/basic_runner.png'},
    {'title': 'Rookie Runner', 'image': 'asset/images/rookie_runner.png'},
    {'title': 'Master Runner', 'image': 'asset/images/master_runner.png'},
    {'title': 'Grand Master Runner', 'image': 'asset/images/grand_master_runner.png'},
    {'title': 'Elite Global Runeer', 'image': 'asset/images/elite_global_runner.png'},
  ];

  static const List<Map<String, String>> _dailyStats = [
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              const SizedBox(height: 4),
              const HomeStreakWidget(),
              const SizedBox(height: 2),
              Center(child: Text("uam"),),
              HorizontalCarousel.cards(
                items: _badges,
                bordered: true,
                cardBuilder: (context, badge) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(badge['image']!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              HorizontalCarousel.cards(
                items: _dailyStats,
                bordered: true,
                cardBuilder: (context, badge) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(badge['image']!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
