import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';

class UnitPickerSheet extends StatelessWidget {
  final SettingsDistanceUnit selected;
  final ValueChanged<SettingsDistanceUnit> onSelected;

  const UnitPickerSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Units of measurement',
              style: TextStyle(
                color: Styles.tabActive,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          for (final unit in SettingsDistanceUnit.values)
            ListTile(
              onTap: () => onSelected(unit),
              title: Text(
                '${unit.label} (${unit.abbreviation})',
                style: TextStyle(
                  color: unit == selected ? Styles.accent : Styles.tabActive,
                  fontSize: 17,
                  fontWeight:
                      unit == selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              trailing: unit == selected
                  ? const Icon(Icons.check, color: Styles.accent)
                  : null,
            ),
        ],
      ),
    );
  }
}

Future<void> showUnitPicker(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    builder: (sheetContext) => UnitPickerSheet(
      selected: ref.read(settingsProvider).unit,
      onSelected: (unit) {
        ref.read(settingsProvider.notifier).setUnit(unit);
        Navigator.of(sheetContext).pop();
      },
    ),
  );
}