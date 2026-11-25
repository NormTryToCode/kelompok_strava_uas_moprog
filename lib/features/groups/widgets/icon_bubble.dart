import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class IconBubble extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBubble(
    this.icon, {
    super.key,
    this.color = Colors.white,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final isNeutral = color == Colors.white || color == Styles.surfaceHighlight;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isNeutral ? Colors.white.withAlpha(16) : color.withAlpha(28),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, size: size * 0.48, color: color),
    );
  }
}
