import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StatisticsSportTabBar extends StatelessWidget {
  final int activeSportIndex;
  final ValueChanged<int> onSelectSport;

  const StatisticsSportTabBar({
    super.key,
    required this.activeSportIndex,
    required this.onSelectSport,
  });

  static const List<IconData> _sportIcons = [
    Icons.directions_bike,
    Icons.directions_run,
    Icons.pool,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.background,
      child: Column(
        children: [
          Row(
            children: List.generate(_sportIcons.length, (index) {
              final bool isSelected = (activeSportIndex == index);
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelectSport(index),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Icon(
                          _sportIcons[index],
                          size: 28,
                          color: isSelected
                              ? Styles.tabActive
                              : Styles.tabInactive,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 32,
                          height: 3.5,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Styles.accent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(
            height: 1,
            color: Styles.inactive,
          ),
        ],
      ),
    );
  }
}