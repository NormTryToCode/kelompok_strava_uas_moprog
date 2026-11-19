import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_heading.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/choice_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class Step5ClubLocation extends StatelessWidget {
  final bool isGlobal;
  final ClubLocation? location;
  final VoidCallback onSelectGlobal;
  final VoidCallback onPickLocation;

  const Step5ClubLocation({
    super.key,
    required this.isGlobal,
    required this.location,
    required this.onSelectGlobal,
    required this.onPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    final picked = location;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        const StepHeading(
          eyebrow: 'Location',
          title: 'Where are you based?',
          subtitle: 'Choose Global if your club isn\u2019t tied to one place.',
        ),
        const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ChoiceCard(
                  icon: Icons.public,
                  title: 'Global',
                  subtitle: 'Open to everyone, anywhere',
                  selected: isGlobal,
                  onTap: onSelectGlobal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceCard(
                  icon: Icons.place_outlined,
                  title: 'A specific place',
                  subtitle: 'Search for a city or region',
                  selected: !isGlobal && picked != null,
                  onTap: onPickLocation,
                ),
              ),
            ],
          ),
        ),
        if (!isGlobal && picked != null) ...[
          const SizedBox(height: 16),
          SoftCard(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            radius: 16,
            child: Row(
              children: [
                const IconBubble(Icons.location_on_outlined, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        picked.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (picked.detail.isNotEmpty)
                        Text(
                          picked.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Styles.tabInactive,
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onPickLocation,
                  style: TextButton.styleFrom(foregroundColor: Styles.accent),
                  child: const Text(
                    'Change',
                    style: TextStyle(fontWeight: FontWeight.w700),
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
