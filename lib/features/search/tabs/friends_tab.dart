import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/suggested_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

class FriendsTab extends StatelessWidget {
  final FollowController? controller;
  final List<Person>? people;

  const FriendsTab({super.key, this.controller, this.people});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchField(hintText: 'Search Strava'),
        Expanded(
          child: SuggestedTab(controller: controller, people: people),
        ),
      ],
    );
  }
}