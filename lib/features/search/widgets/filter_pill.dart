import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? Styles.accent : Styles.tabActive,
        backgroundColor: isActive
            ? Styles.accent.withValues(alpha: 0.12)
            : Colors.transparent,
        shape: const StadiumBorder(),
        side: BorderSide(color: isActive ? Styles.accent : Colors.white54),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(iconData, size: 18),
            const SizedBox(width: 6),
          ],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }
}