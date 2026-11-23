import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StatisticMetricItem {
  final String label;
  final String value;

  const StatisticMetricItem({
    required this.label,
    required this.value,
  });
}

class StatisticsSectionTable extends StatelessWidget {
  final String sectionTitle;
  final List<StatisticMetricItem> items;

  const StatisticsSectionTable({
    super.key,
    required this.sectionTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
                color: Styles.primaryLight,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: Styles.cardDecoration(radius: Radii.field),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final bool isLast = index == items.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Styles.textSecondary,
                            ),
                          ),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Divider(height: 1, color: Styles.divider),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}