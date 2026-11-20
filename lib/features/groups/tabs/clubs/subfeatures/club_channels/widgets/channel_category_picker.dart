import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';

class ChannelCategoryPicker extends StatelessWidget {
  final ChannelCategory selected;
  final ValueChanged<ChannelCategory> onChanged;

  const ChannelCategoryPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final category in ChannelCategory.values)
          _CategoryOptionChip(
            category: category,
            selected: category == selected,
            onTap: () => onChanged(category),
          ),
      ],
    );
  }
}

class _CategoryOptionChip extends StatelessWidget {
  final ChannelCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryOptionChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                size: 18,
                color: selected ? Palette.teal : Styles.tabInactive,
              ),
              const SizedBox(width: 8),
              Text(
                category.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Styles.tabInactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}