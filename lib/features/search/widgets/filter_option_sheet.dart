import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class FilterOptionSheet<T> extends StatelessWidget {
  final String title;
  final String allLabel;
  final List<T> options;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T?> onSelected;

  const FilterOptionSheet({
    super.key,
    required this.title,
    required this.allLabel,
    required this.options,
    required this.labelOf,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Styles.tabActive,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _OptionRow(
            label: allLabel,
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final option in options)
                  _OptionRow(
                    label: labelOf(option),
                    isSelected: option == selected,
                    onTap: () => onSelected(option),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Styles.accent : Styles.tabActive,
          fontSize: 17,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Styles.accent)
          : null,
    );
  }
}

Future<void> showFilterSheet<T>({
  required BuildContext context,
  required String title,
  required String allLabel,
  required List<T> options,
  required String Function(T) labelOf,
  required T? selected,
  required ValueChanged<T?> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    builder: (sheetContext) => FilterOptionSheet<T>(
      title: title,
      allLabel: allLabel,
      options: options,
      labelOf: labelOf,
      selected: selected,
      onSelected: (value) {
        onSelected(value);
        Navigator.of(sheetContext).pop();
      },
    ),
  );
}