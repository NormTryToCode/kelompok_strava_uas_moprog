import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubLogoPlaceholder extends StatelessWidget {
  final double size;

  const ClubLogoPlaceholder({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Styles.inactive,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.flag, size: size * 0.5, color: Styles.background),
    );
  }
}
