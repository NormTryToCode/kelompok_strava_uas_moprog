import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class EventToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const EventToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: Styles.tabInactive,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Palette.teal
                : Styles.inactive,
          ),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ],
    );
  }
}
