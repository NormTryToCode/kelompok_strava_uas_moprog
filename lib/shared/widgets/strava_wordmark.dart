import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StravaWordmark extends StatelessWidget {
  const StravaWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'STRAVA',
      style: TextStyle(
        color: Styles.tabActive,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }
}