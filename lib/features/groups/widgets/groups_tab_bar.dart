import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class GroupsTabBar extends StatelessWidget {
  const GroupsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(Radii.button + 4),
        border: Border.all(color: Styles.border),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: Styles.linearGradient(
            colors: const [Styles.primary, Styles.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(Radii.button),
          boxShadow: Styles.glow(intensity: 0.38, blur: 16),
        ),
        labelColor: Styles.textPrimary,
        unselectedLabelColor: Styles.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        tabs: const [
          Tab(height: 40, text: 'Challenges'),
          Tab(height: 40, text: 'Clubs'),
          Tab(height: 40, text: 'Events'),
        ],
      ),
    );
  }
}