import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_option_tile.dart';

Future<ClubSport?> showSportPickerSheet(
  BuildContext context, {
  required ClubSport? selected,
}) {
  final sports =
      ClubSport.all.where((s) => s.id != ClubSport.allSports.id).toList();

  return showModalBottomSheet<ClubSport>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final height = MediaQuery.of(sheetContext).size.height * 0.8;

      return SizedBox(
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Sport',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sports.length,
                  itemBuilder: (_, i) => SportOptionTile(
                    sport: sports[i],
                    selected: sports[i].id == selected?.id,
                    onTap: () => Navigator.of(sheetContext).pop(sports[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
