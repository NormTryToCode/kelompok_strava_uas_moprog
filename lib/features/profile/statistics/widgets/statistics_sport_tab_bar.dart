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
    'Cycling',
    'Running',
    'Swimming',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Styles.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Styles.borderStrong),
        ),
        child: Row(
          children: List.generate(_sportIcons.length, (index) {
            final bool isSelected = (activeSportIndex == index);
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelectSport(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 6.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? Styles.primaryGradient : null,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                      ? Styles.glow(intensity: 0.28, blur: 12)
                      : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _sportIcons[index],
                        size: 18,
                        color: isSelected
                          ? Styles.canvas
                          : Styles.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _sportLabels[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                            color: isSelected
                              ? Styles.canvas
                              : Styles.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}