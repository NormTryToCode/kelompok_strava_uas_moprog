import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class ClubInfoRow extends StatelessWidget {
  final Club club;

  const ClubInfoRow({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final isPrivate = club.privacy.id == ClubPrivacy.private.id;

    return Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        _InfoItem(icon: club.sport.icon, label: club.sport.name),
        _InfoItem(icon: Icons.people_outline, label: club.memberLabel),
        _InfoItem(
          icon: isPrivate ? Icons.lock_outline : Icons.public,
          label: club.privacy.name,
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: Colors.white),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
