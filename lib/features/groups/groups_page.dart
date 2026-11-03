import 'package:flutter/material.dart';

import 'tabs/challenges_tab.dart';
import 'tabs/clubs_tab.dart';
import 'tabs/events_tab.dart';

import '../../theme/styles.dart';
import 'widgets/groups_tab_bar.dart';

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

