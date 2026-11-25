import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/clubs_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SearchPage extends StatelessWidget {
  final int initialTab;

  const SearchPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: const Scaffold(
        backgroundColor: Styles.canvas,
        appBar: AppHeader(title: 'Search', showBackButton: true),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Styles.accent,
              labelColor: Styles.primaryLight,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'Friends'),
                Tab(text: 'Clubs'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FriendsTab(),
                  SearchClubsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

