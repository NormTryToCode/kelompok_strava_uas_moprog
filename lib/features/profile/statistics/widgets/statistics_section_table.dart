import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StatisticMetricItem {
  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  const StatisticMetricItem({
    required this.label,
    required this.value,
    this.icon = Icons.analytics_outlined,
    this.highlight = false,
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
    final List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      final bool hasPair = i + 1 < items.length;
      if (hasPair) {
        rows.add(
          Row(
            children: [
              Expanded(child: _BentoMetricTile(item: items[i])),
              const SizedBox(width: 10),
              Expanded(child: _BentoMetricTile(item: items[i + 1])),
            ],
          ),
        );
      } else {
        rows.add(_BentoMetricTile(item: items[i], isWide: true));
      }
      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: 10));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  gradient: Styles.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                sectionTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: Styles.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...rows,
        ],
      ),
    );
  }
}

class _BentoMetricTile extends StatelessWidget {
  final StatisticMetricItem item;
  final bool isWide;

  const _BentoMetricTile({
    required this.item,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: Styles.cardDecoration(
        radius: Radii.field,
        highlighted: item.highlight,
      ),
      padding: const EdgeInsets.all(14.0),
      child: isWide
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Styles.surfaceHighlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: Styles.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Styles.textPrimary,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Styles.surfaceHighlight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      size: 16,
                      color: Styles.primaryLight,
                    ),
                  ),
                  if (item.highlight)
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: Styles.primaryLight,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
    );
  }
}