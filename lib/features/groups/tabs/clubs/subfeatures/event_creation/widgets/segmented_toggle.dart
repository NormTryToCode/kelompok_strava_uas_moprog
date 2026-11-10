import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class SegmentedToggle<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final String Function(T option) labelOf;
  final ValueChanged<T> onChanged;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Palette.fieldFill,
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(color: Palette.cardBorder),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: option == selected
                        ? Palette.selectedFill
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Radii.chip - 2),
                    border: Border.all(
                      color: option == selected
                          ? Palette.teal
                          : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    labelOf(option),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: option == selected
                          ? Colors.white
                          : Styles.tabInactive,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
