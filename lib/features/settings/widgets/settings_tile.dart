import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final subtitleText = subtitle;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: titleColor ?? Styles.tabActive),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Styles.tabActive,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitleText == null
          ? null
          : Text(
              subtitleText,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: Colors.white54)
          : null,
    );
  }
}