import 'package:flutter/material.dart';

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
        label: Text('$badgeCount'),
        child: Icon(icon),
      ),
      onPressed: onPressed,
    );
  }
}