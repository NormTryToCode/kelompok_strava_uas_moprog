import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';

class ClubTypeChip extends StatelessWidget {
  final ClubType type;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const ClubTypeChip({
    super.key,
    required this.type,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tappable = enabled || selected;

    return Opacity(
      opacity: tappable ? 1 : 0.4,
      child: Material(
        color: selected ? Palette.selectedFill : Styles.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.chip + 2),
          side: BorderSide(
            color: selected ? Palette.teal : Palette.cardBorder,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: InkWell(
          onTap: tappable ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check : type.icon,
                  size: 18,
                  color: selected ? Palette.teal : Styles.tabInactive,
                ),
                const SizedBox(width: 8),
                Text(
                  type.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
