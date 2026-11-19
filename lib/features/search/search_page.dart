import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/clubs_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppHeader(title: 'Search', showBackButton: true),
        body: Column(
          children: [
            TabBar(
              indicatorColor: Styles.accent,
              labelColor: Styles.tabActive,
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
                  ClubsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}