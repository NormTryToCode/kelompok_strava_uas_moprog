import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_option_tile.dart';

class Step1SportSelection extends StatelessWidget {
  final ClubSport selected;
  final ValueChanged<ClubSport> onChanged;

  const Step1SportSelection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 24),
          child: _Heading(),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: ClubSport.option.length,
            itemBuilder: (_, i) {
              final sport = ClubSport.option[i];
              return SportOptionTile(
                sport: sport,
                selected: sport.id == selected.id,
                onTap: () => onChanged(sport),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose your club\u2019s sport",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Go broad with 'All Sports' or be specific with one sport type.",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
