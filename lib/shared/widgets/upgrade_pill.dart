import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class UpgradePill extends StatelessWidget {
  final VoidCallback? onTap;

  const UpgradePill({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(
          Icons.local_fire_department_outlined,
          size: 18,
          color: Styles.accent,
        ),
        label: const Text(
          'Upgrade',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Styles.tabActive,
          shape: const StadiumBorder(),
          side: const BorderSide(color: Styles.accent),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}