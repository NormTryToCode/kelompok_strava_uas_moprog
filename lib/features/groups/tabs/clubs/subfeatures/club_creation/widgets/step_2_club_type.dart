import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/club_type_option_tile.dart';

class Step2ClubType extends StatelessWidget {
  final List<ClubType> selected;
  final int maxSelection;
  final ValueChanged<ClubType> onToggle;

  const Step2ClubType({
    super.key,
    required this.selected,
    required this.maxSelection,
    required this.onToggle,
  });

  bool _isSelected(ClubType type) => selected.any((t) => t.id == type.id);

  @override
  Widget build(BuildContext context) {
    final reachedLimit = selected.length >= maxSelection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: _Heading(count: selected.length, max: maxSelection),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            itemCount: ClubType.option.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final type = ClubType.option[i];
              return ClubTypeOptionTile(
                type: type,
                selected: _isSelected(type),
                enabled: !reachedLimit,
                onTap: () => onToggle(type),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  final int count;
  final int max;

  const _Heading({required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What kind of club is this?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose up to $max tags so people know what to expect.',
          style: const TextStyle(fontSize: 16, color: Styles.tabInactive),
        ),
        const SizedBox(height: 12),
        Text(
          '$count of $max selected',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: count > 0 ? Styles.accent : Styles.tabInactive,
          ),
        ),
      ],
    );
  }
}
