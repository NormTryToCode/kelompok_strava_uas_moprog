import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class ClubPickerSheet extends StatelessWidget {
  final List<Club> clubs;
  final ValueChanged<Club> onSelected;

  const ClubPickerSheet({
    super.key,
    required this.clubs,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Choose a club',
                style: TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (clubs.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Text(
                  'No clubs available yet. Create a club in the Groups tab first.',
                  style: TextStyle(color: Styles.textSecondary, fontSize: 14),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clubs.length,
                  itemBuilder: (_, index) {
                    final club = clubs[index];
                    return ListTile(
                      onTap: () => onSelected(club),
                      leading: CircleAvatar(
                        backgroundColor: Styles.surfaceHighlight,
                        foregroundColor: Styles.primaryLight,
                        child: Icon(club.sport.icon, size: 20),
                      ),
                      title: Text(
                        club.name,
                        style: const TextStyle(
                          color: Styles.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${club.memberLabel} • ${club.locationLabel}',
                        style: const TextStyle(
                          color: Styles.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Styles.textMuted,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<Club?> showClubPickerSheet(BuildContext context, List<Club> clubs) {
  return showModalBottomSheet<Club>(
    context: context,
    backgroundColor: Styles.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => ClubPickerSheet(
      clubs: clubs,
      onSelected: (club) => Navigator.of(sheetContext).pop(club),
    ),
  );
}