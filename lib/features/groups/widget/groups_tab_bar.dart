import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widget/tab_label_with_badge.dart';

class GroupsTabBar extends StatelessWidget {
  const GroupsTabBar({super.key});

  static const _labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.divider, width: 1)),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        labelColor: Styles.tabActive,
        unselectedLabelColor: Styles.tabInactive,
        labelStyle: _labelStyle,
        unselectedLabelStyle: _labelStyle,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
          borderSide: BorderSide(color: Styles.accent, width: 4),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(text: 'Challenges'),
          Tab(text: 'Clubs'),
          Tab(text: 'Events'),
        ],
      ),
    );
  }
}
