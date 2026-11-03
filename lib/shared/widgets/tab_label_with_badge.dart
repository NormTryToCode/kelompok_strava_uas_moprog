import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/theme/styles.dart';

class TabLabelWithBadge extends StatelessWidget {
  //class untuk notifikasi, belum terpasang karena functionnya belum lengkap
  final String label;
  final bool showBadge;

  const TabLabelWithBadge({
    super.key,
    required this.label,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Text(label),
        if (showBadge)
          const Positioned(
            top: 0,
            right: -10,
            child: CircleAvatar(radius: 3.5, backgroundColor: Styles.badge),
          ),
      ],
    );
  }
}
