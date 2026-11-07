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
    return IconButton(
      icon: Badge(
        isLabelVisible: badgeCount > 0,
        backgroundColor: Styles.accent,
        textColor: Styles.tabActive,
        label: Text('$badgeCount'),
        child: Icon(icon),
      ),
      onPressed: onPressed,
    );
  }
}