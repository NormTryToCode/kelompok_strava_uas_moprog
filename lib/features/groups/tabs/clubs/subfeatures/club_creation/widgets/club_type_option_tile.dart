import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';

import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubTypeOptionTile extends StatelessWidget {
  final ClubType type;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const ClubTypeOptionTile({super.key, required this.type, required this.selected, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tappable = enabled || selected;

    return Opacity(
      opacity: tappable ? 1 : 0.4,
      child: Material(
        color: selected ? Styles.accent.withAlpha(36) : Styles.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? Styles.accent : Styles.inactive,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: InkWell(
          onTap: tappable ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Icon(
                  type.icon,
                  size: 24,
                  color: selected ? Styles.accent : Styles.tabInactive,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    type.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, size: 24, color: Styles.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}