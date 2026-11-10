import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/sport_grid_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_heading.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

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
    final subsports = selected.subsports;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        const StepHeading(
          eyebrow: 'Sport',
          title: 'What will your club do?',
          subtitle: 'Pick one sport, or keep it open with All Sports.',
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: ClubSport.option.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 76,
          ),
          itemBuilder: (_, index) {
            final sport = ClubSport.option[index];
            return SportGridTile(
              sport: sport,
              selected: sport.id == selected.id,
              onTap: () => onChanged(sport),
            );
          },
        ),
        if (subsports != null) ...[
          const SizedBox(height: 16),
          SoftCard(
            padding: const EdgeInsets.all(14),
            radius: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: Palette.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Includes: $subsports',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Styles.tabInactive,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
