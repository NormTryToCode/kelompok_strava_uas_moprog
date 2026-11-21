import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/club_type_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_grid_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';

Future<ClubSport?> showClubSportPickerSheet(
  BuildContext context, {
  required ClubSport selected,
}) {
  return showModalBottomSheet<ClubSport>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final height = MediaQuery.of(sheetContext).size.height * 0.78;

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
                  itemCount: ClubSport.option.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 76,
                  ),
                  itemBuilder: (_, i) {
                    final sport = ClubSport.option[i];
                    return SportGridTile(
                      sport: sport,
                      selected: sport.id == selected.id,
                      onTap: () => Navigator.of(sheetContext).pop(sport),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<List<ClubType>?> showClubTypePickerSheet(
  BuildContext context, {
  required List<ClubType> initialSelected,
}) {
  return showModalBottomSheet<List<ClubType>>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final selected = List<ClubType>.of(initialSelected);

      return StatefulBuilder(
        builder: (context, setModalState) {
          final reachedLimit = selected.length >= ClubCreationPage.maxTypes;

          void toggle(ClubType type) {
            setModalState(() {
              final index = selected.indexWhere((t) => t.id == type.id);
              if (index >= 0) {
                selected.removeAt(index);
              } else if (!reachedLimit) {
                selected.add(type);
              }
            });
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Styles.inactive,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Club Type',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '${selected.length} of ${ClubCreationPage.maxTypes}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Palette.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final type in ClubType.option)
                        ClubTypeChip(
                          type: type,
                          selected: selected.any((t) => t.id == type.id),
                          enabled: !reachedLimit,
                          onTap: () => toggle(type),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Done',
                    onPressed: selected.isEmpty
                        ? null
                        : () => Navigator.of(sheetContext).pop(selected),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}