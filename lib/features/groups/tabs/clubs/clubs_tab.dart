import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/create_club_bar.dart';

class ClubsTab extends StatelessWidget {
  const ClubsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreateClubBar(onCreate: () => ClubCreationPage.open(context)),
      ],
    );
  }
}
