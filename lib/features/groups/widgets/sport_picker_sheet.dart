import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_grid_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/sheet_handle.dart';

Future<ClubSport?> showSportPickerSheet(
  BuildContext context, {
  required ClubSport? selected,
  bool includeAllSports = false,
}) {
  final sports = includeAllSports
      ? ClubSport.option
      : ClubSport.option.where((s) => s.id != ClubSport.allSports.id).toList();

  return showModalBottomSheet<ClubSport>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final height = MediaQuery.of(sheetContext).size.height * 0.78;

      return SizedBox(
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetHandle(),
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
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 72,
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