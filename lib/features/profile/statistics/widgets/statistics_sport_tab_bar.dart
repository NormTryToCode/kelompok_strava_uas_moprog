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
    Icons.directions_bike_rounded,
    Icons.directions_run_rounded,
    Icons.pool_rounded,
  ];

  static const List<String> _sportLabels = [
    'Sepeda',
    'Lari',
    'Renang',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.canvas,
      child: Column(
        children: [
          Row(
            children: List.generate(_sportIcons.length, (index) {
              final bool isSelected = (activeSportIndex == index);
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelectSport(index),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Icon(
                          _sportIcons[index],
                          size: 25,
                          color: isSelected
                            ? Styles.primaryLight
                            : Styles.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _sportLabels[index],
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                            color: isSelected
                              ? Styles.textPrimary
                              : Styles.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 44,
                          height: 3.5,
                          decoration: BoxDecoration(
                            gradient: isSelected ? Styles.primaryGradient : null,
                            color: isSelected ? null : Colors.transparent,
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
          Container(height: 1, color: Styles.border),
        ],
      ),
    );
  }
}