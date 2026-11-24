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
    return Container(
      color: Styles.canvas,
      child: Column(
        children: [
          Row(
            children: [
              _TabItem(
                icon: Icons.assessment_rounded,
                label: 'Kemajuan',
                isActive: activeTab == 0,
                onTap: onTapKemajuan,
              ),
              _TabItem(
                icon: Icons.timeline_rounded,
                label: 'Aktivitas',
                isActive: activeTab == 1,
                onTap: onTapAktivitas,
              ),
              _TabItem(
                icon: Icons.menu_rounded,
                label: 'Lainnya',
                isActive: activeTab == 2,
                onTap: onTapLainnya,
              ),
            ],
          ),
          Container(
            height: 1,
            color: Styles.border,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
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
        child: Column(
          children: [
            const SizedBox(height: 6),
            Icon(
              icon,
              size: 22,
              color: isActive ? Styles.primaryLight : Styles.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Styles.textPrimary : Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: isActive ? Styles.primaryGradient : null,
                color: isActive ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}