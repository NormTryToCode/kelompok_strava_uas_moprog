import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';

class ClubInfoRow extends StatelessWidget {
  final Club club;

  const ClubInfoRow({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final isPrivate = club.privacy.id == ClubPrivacy.private.id;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        InfoChip(icon: club.sport.icon, label: club.sport.name),
        InfoChip(icon: Icons.people_outline, label: club.memberLabel),
        InfoChip(
          icon: isPrivate ? Icons.lock_outline : Icons.public,
          label: club.privacy.name,
        ),
      ],
    );
  }
}
