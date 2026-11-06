import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubActionButtons extends StatelessWidget {
  final VoidCallback onTap;

  const ClubActionButtons({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person_add_alt, 'Invite'),
      (Icons.edit_outlined, 'Edit Club Details'),
      (Icons.share_outlined, 'Share'),
      (Icons.insights_outlined, 'Event Insights'),
      (Icons.groups_outlined, 'Members'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            _ActionItem(icon: item.$1, label: item.$2, onTap: onTap),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          Material(
            color: Styles.inactive,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 64,
                height: 64,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
