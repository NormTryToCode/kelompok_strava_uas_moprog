import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

enum FieldTag { required, optional, none }

class EventFieldLabel extends StatelessWidget {
  final String label;
  final FieldTag tag;
  final String? badge;

  const EventFieldLabel(
    this.label, {
    super.key,
    this.tag = FieldTag.none,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Styles.accent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (tag != FieldTag.none)
          Text(
            tag == FieldTag.required ? 'Required' : 'Optional',
            style: const TextStyle(fontSize: 14, color: Styles.tabInactive),
          ),
      ],
    );
  }
}
