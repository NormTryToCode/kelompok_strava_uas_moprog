import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class GroupsTabBar extends StatelessWidget {
  const GroupsTabBar({super.key});

  static const _labelStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Palette.cardBorder),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Styles.tabInactive,
        labelStyle: _labelStyle,
        unselectedLabelStyle: _labelStyle,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        indicator: BoxDecoration(
          color: Palette.selectedFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Palette.teal, width: 1.4),
        ),
        tabs: const [
          Tab(height: 40, text: 'Challenges'),
          Tab(height: 40, text: 'Clubs'),
          Tab(height: 40, text: 'Events'),
        ],
      ),
    );
  }
}
