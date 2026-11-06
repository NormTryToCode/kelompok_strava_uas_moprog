import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/location_option_tile.dart';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where is your club based?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose Global if it isn\u2019t tied to a single place.',
            style: TextStyle(fontSize: 16, color: Styles.tabInactive),
          ),
          const SizedBox(height: 32),
          LocationOptionTile(
            icon: Icons.public,
            title: 'Global',
            selected: isGlobal,
            onTap: onSelectGlobal,
          ),
          const SizedBox(height: 12),
          LocationOptionTile(
            icon: Icons.place_outlined,
            title: picked?.name ?? 'Choose a place',
            subtitle: picked?.detail,
            actionLabel: picked == null ? 'Search' : 'Change',
            selected: !isGlobal && picked != null,
            onTap: onPickLocation,
          ),
        ],
      ),
    );
  }
}
