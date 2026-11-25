import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfileTabBar extends StatelessWidget {
  final int activeTab;
  final VoidCallback onTapKemajuan;
  final VoidCallback onTapAktivitas;
  final VoidCallback onTapLainnya;

  const ProfileTabBar({
    super.key,
    required this.activeTab,
    required this.onTapKemajuan,
    required this.onTapAktivitas,
    required this.onTapLainnya,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Styles.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Styles.borderStrong),
        ),
        child: Row(
          children: [
            _DockPill(
              icon: Icons.speed_rounded,
              label: 'Pulse',
              isActive: activeTab == 0,
              onTap: onTapKemajuan,
            ),
            _DockPill(
              icon: Icons.auto_stories_rounded,
              label: 'Journal',
              isActive: activeTab == 1,
              onTap: onTapAktivitas,
            ),
            _DockPill(
              icon: Icons.grid_view_rounded,
              label: 'Vault',
              isActive: activeTab == 2,
              onTap: onTapLainnya,
            ),
          ],
        ),
      ),
    );
  }
}

class _DockPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DockPill({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            gradient: isActive ? Styles.primaryGradient : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isActive ? Styles.glow(intensity: 0.25, blur: 12) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isActive ? Styles.canvas : Styles.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    color: isActive ? Styles.canvas : Styles.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}