import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_grid_tile.dart';

Future<ClubSport?> showSportPickerSheet(
  BuildContext context, {
  required ClubSport? selected,
}) {
  final sports =
      ClubSport.option.where((s) => s.id != ClubSport.allSports.id).toList();

  return showModalBottomSheet<ClubSport>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final height = MediaQuery.of(sheetContext).size.height * 0.8;

      return SizedBox(
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Styles.inactive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Choose a sport',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: sports.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 76,
                  ),
                  itemBuilder: (_, i) => SportGridTile(
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
