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
      decoration: const BoxDecoration(
        color: Styles.background,
        border: Border(
          bottom: BorderSide(color: Palette.cardBorder, width: 1),
        ),
      ),
      child: const TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2.5,
        indicatorColor: Styles.accent,
        labelColor: Colors.white,
        unselectedLabelColor: Styles.tabInactive,
        labelStyle: _labelStyle,
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        tabs: [
          Tab(height: 44, text: 'Challenges'),
          Tab(height: 44, text: 'Clubs'),
          Tab(height: 44, text: 'Events'),
        ],
      ),
    );
  }
}
