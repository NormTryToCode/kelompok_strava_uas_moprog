import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final int badgeCount;

  const HeaderIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Styles.surface,
          foregroundColor: Styles.tabActive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Palette.cardBorder),
          ),
        ),
        icon: Badge(
          isLabelVisible: badgeCount > 0,
          backgroundColor: Styles.badge,
          textColor: Styles.tabActive,
          label: Text('$badgeCount'),
          child: Icon(icon, size: 21),
        ),
        onPressed: onPressed,
      ),
    );
  }
}