import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/badges_section.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/daily_stats_section.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/streak_chart_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/welcome_banner_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/daily_challenges_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/stride_wordmark.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
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
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SearchPage())),
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(top: 12, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 22,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: WelcomeBannerWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DailyChallengeWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: StreakChartWidget(),
            ),
            DailyStatsSection(),
            BadgesSection(),
          ],
        ),
      ),
    );
  }
}
