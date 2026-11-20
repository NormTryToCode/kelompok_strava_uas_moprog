import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/challenges_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/clubs_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/events_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/groups_tab_bar.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

class GroupsPage extends StatelessWidget {
  final int initialTab;

  const GroupsPage({super.key, this.initialTab = 2});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab,
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppHeader(
          title: 'Groups',
          actions: [
            HeaderIconButton(
              icon: Icons.forum_outlined,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const FriendsPage()),
              ),
            ),
            HeaderIconButton(
              icon: Icons.search,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SearchPage()),
              ),
            ),
            HeaderIconButton(
              icon: Icons.settings_outlined,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
              ),
            ),
          ],
        ),
        body: const Column(
          children: [
            GroupsTabBar(),
            Expanded(
              child: TabBarView(
                children: [ChallengesTab(), ClubsTab(), EventsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}