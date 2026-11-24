import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/club_share_service.dart';

class ShareActionTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget icon;

  const ShareActionTile._({
    required this.label,
    required this.onTap,
    required this.icon,
  });

  factory ShareActionTile.app({
    required ShareTarget target,
    required VoidCallback? onTap,
  }) {
    return ShareActionTile._(
      label: target.label,
      onTap: onTap,
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          color: Styles.surface,
          child: target.iconBytes.isNotEmpty
              ? Image.memory(
                  target.iconBytes,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.apps, color: Styles.teal, size: 26),
                )
              : const Icon(Icons.apps, color: Styles.teal, size: 26),
        ),
      ),
    );
  }

  factory ShareActionTile.utility({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool busy = false,
  }) {
    return ShareActionTile._(
      label: label,
      onTap: onTap,
      icon: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Styles.surface,
          border: Border.all(color: Styles.cardBorder, width: 1.2),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Styles.teal,
                ),
              )
            : Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 8),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

