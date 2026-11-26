import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

class RecordActionCardButton extends StatelessWidget {
  final String action;

  const RecordActionCardButton({super.key, required this.action});

  String get sportId => switch (action) {
    "Walk" || "Run" => "run-walk-hike",
    "Ride" => "cycling",
    _ => "run-walk-hike",
  };
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: TextButton(
        onPressed: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    ClubSport.option
                        .firstWhere((cur_sport) => cur_sport.id == sportId)
                        .icon,
                  ),
                  label: Text(
                    '$action',
                    style: TextStyle(color: Styles.canvas),
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.play_arrow),
              label: Text("Start", style: TextStyle(color: Styles.textPrimary)),
              style: TextButton.styleFrom(
                backgroundColor: Styles.primary,
                minimumSize: Size(340.0, 40.0),
              ),
            ),
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: Styles.textPrimary,
          alignment: Alignment.topLeft,
          minimumSize: Size(370, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
