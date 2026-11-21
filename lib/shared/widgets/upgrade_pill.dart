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
          Icons.auto_awesome_outlined,
          size: 16,
          color: Styles.champagne,
        ),
        label: const Text(
          'Upgrade',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Styles.champagne,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Styles.deepTeal.withAlpha(110),
          foregroundColor: Styles.champagne,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.chip),
          ),
          side: const BorderSide(color: Styles.champagne),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}