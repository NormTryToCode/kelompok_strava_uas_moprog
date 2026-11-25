import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

class SpotFilterBar extends StatelessWidget {
  final SpotType? selected; // null = semua
  final ValueChanged<SpotType?> onChanged;

  const SpotFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  Widget _chip(String label, SpotType? value) {
    return ChoiceChip(
      label: Text(label),
      selected: selected == value,
      onSelected: (_) => onChanged(value),
      selectedColor: Styles.accent,
      backgroundColor: Styles.surface,
      labelStyle: const TextStyle(color: Colors.white),
      showCheckmark: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Semua', null),
        const SizedBox(width: 8),
        _chip('Lari', SpotType.run),
        const SizedBox(width: 8),
        _chip('Sepeda', SpotType.bike),
      ],
    );
  }
}