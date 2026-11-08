import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_streak_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/upgrade_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppHeader(
        leadingWidget: const UpgradePill(),
        actions: [
          AddMenuButton(onSelected: (_) => _comingSoon(context)),
          HeaderIconButton(
            icon: Icons.forum_outlined,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsPage())),
          ),
          HeaderIconButton(
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          ListenableBuilder(
            listenable: NotificationController.instance,
            builder: (context, _) => HeaderIconButton(
              icon: Icons.notifications_none,
              badgeCount: NotificationController.instance.unreadCount,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              ),
            ),
          ),
        ],
      ),
      body: const SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.0),
            HomeStreakWidget(),
          ],
        ),
      ),
    );
  }
}