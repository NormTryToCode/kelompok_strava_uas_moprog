import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

class SpotMarker extends StatelessWidget {
  final SpotType type;

  const SpotMarker({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.accent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(
        type == SpotType.run ? Icons.directions_run : Icons.directions_bike,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}