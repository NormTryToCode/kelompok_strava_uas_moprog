import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SearchField(hintText: 'Search Strava'),
        Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}