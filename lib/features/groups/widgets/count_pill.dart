import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CountPill extends StatelessWidget {
  final int count;
  final String? label;

  const CountPill({super.key, required this.count, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Styles.cardBorder),
      ),
      child: Text(
        label ?? '$count',
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Styles.textSecondary,
        ),
      ),
    );
  }
}

