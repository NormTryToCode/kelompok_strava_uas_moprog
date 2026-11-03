import 'package:flutter/material.dart';

import 'package:kelompok_strava_uas_moprog/features/challenges/challenges_page.dart';
import 'package:kelompok_strava_uas_moprog/features/clubs/clubs_page.dart';
import 'package:kelompok_strava_uas_moprog/features/events/events_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/groups_page.dart';

import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/groups_tab_bar.dart';

class GroupsPage extends StatelessWidget {
  final int initialTab;

  const GroupsPage({super.key, this.initialTab = 2});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab,
      child: const Material(
        color: Styles.background,
        child: Column(
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
