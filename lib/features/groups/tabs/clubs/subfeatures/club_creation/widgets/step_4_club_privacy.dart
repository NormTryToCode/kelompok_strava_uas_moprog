import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_heading.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/choice_card.dart';

class Step4ClubPrivacy extends StatelessWidget {
  final ClubPrivacy selected;
  final ValueChanged<ClubPrivacy> onChanged;

  const Step4ClubPrivacy({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        const StepHeading(
          eyebrow: 'Privacy',
          title: 'Who can join?',
          subtitle: 'Pick how people get into your club.',
        ),
        const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < ClubPrivacy.option.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: ChoiceCard(
                    icon: ClubPrivacy.option[i].id == ClubPrivacy.private.id
                        ? Icons.lock_outline
                        : Icons.public,
                    title: ClubPrivacy.option[i].name,
                    subtitle: ClubPrivacy.option[i].description,
                    selected: ClubPrivacy.option[i].id == selected.id,
                    onTap: () => onChanged(ClubPrivacy.option[i]),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'You can change this later in the club settings.',
          style: TextStyle(fontSize: 13, color: Styles.tabInactive),
        ),
      ],
    );
  }
}
