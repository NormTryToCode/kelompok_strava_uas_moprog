import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/contacts_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/qr_code_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/suggested_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/invite_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

class FriendsTab extends StatelessWidget {
  final FollowController? controller;
  final List<Person>? people;

  const FriendsTab({super.key, this.controller, this.people});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SearchField(hintText: 'Search Strava'),
          const TabBar(
            indicatorColor: Styles.accent,
            labelColor: Styles.tabActive,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: 'Suggested'),
              Tab(icon: Icon(Icons.contacts_outlined), text: 'Contacts'),
              Tab(icon: Icon(Icons.qr_code_scanner), text: 'QR Code'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SuggestedTab(controller: controller, people: people),
                const ContactsTab(),
                const QrCodeTab(),
              ],
            ),
          ),
          const InviteButton(),
        ],
      ),
    );
  }
}