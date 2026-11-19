import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubsResultBar extends StatelessWidget {
  final int count;
  final bool isFiltered;
  final VoidCallback onClear;

  const ClubsResultBar({
    super.key,
    required this.count,
    required this.isFiltered,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Text(
              count == 1 ? '1 club' : '$count clubs',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const Spacer(),
            if (isFiltered)
              TextButton(
                onPressed: onClear,
                child: const Text(
                  'Clear filters',
                  style: TextStyle(
                    color: Styles.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}