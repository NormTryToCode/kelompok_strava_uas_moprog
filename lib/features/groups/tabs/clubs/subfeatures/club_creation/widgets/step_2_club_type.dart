import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/club_type_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_heading.dart';

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        StepHeading(
          eyebrow: 'Type',
          title: 'What is your club about?',
          subtitle: 'Choose up to $maxSelection tags so people know what to expect.',
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: _CounterPill(count: selected.length, max: maxSelection),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final type in ClubType.option)
              ClubTypeChip(
                type: type,
                selected: _isSelected(type),
                enabled: !reachedLimit,
                onTap: () => onToggle(type),
              ),
          ],
        ),
      ],
    );
  }
}

class _CounterPill extends StatelessWidget {
  final int count;
  final int max;

  const _CounterPill({required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    final active = count > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Palette.teal.withAlpha(34) : Styles.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count of $max selected',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: active ? Palette.teal : Styles.tabInactive,
        ),
      ),
    );
  }
}
