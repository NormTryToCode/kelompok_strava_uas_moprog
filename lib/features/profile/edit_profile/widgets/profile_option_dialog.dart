import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfileOptionDialog extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const ProfileOptionDialog({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: const BorderSide(color: Styles.borderStrong, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(options.length, (index) {
              final String option = options[index];
              final bool isSelected = (option == selectedValue);

              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Material(
                  color: isSelected
                    ? Styles.surfaceHighlight.withValues(alpha: 0.7)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(Radii.chip),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                            color: isSelected
                              ? Styles.primaryLight
                              : Styles.textSecondary,
                            size: 23,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                                color: isSelected
                                  ? Styles.primaryLight
                                  : Styles.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}