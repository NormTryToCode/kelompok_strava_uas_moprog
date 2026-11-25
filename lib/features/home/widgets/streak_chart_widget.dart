import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class _MetricConfig {
  final String label;
  final String unit;
  final Color color;
  final double maxY;
  final double goalY;
  final String goalLabel;
  final List<double> data;

  const _MetricConfig({
    required this.label,
    required this.unit,
    required this.color,
    required this.maxY,
    required this.goalY,
    required this.goalLabel,
    required this.data,
  });
}

class StreakChartWidget extends StatefulWidget {
  const StreakChartWidget({super.key});

  @override
  State<StreakChartWidget> createState() => _StreakChartWidgetState();
}

class _StreakChartWidgetState extends State<StreakChartWidget> {
  int _selectedTab = 0;
  int _touchedIndex = -1;

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<_MetricConfig> _metrics = [
    _MetricConfig(
      label: 'Distance',
      unit: 'km',
      color: Styles.primary,
      maxY: 10,
      goalY: 5,
      goalLabel: '5 km goal',
      data: [2, 4, 3, 6, 5, 7, 4],
    ),
    _MetricConfig(
      label: 'Calories',
      unit: 'kcal',
      color: Styles.danger,
      maxY: 900,
      goalY: 500,
      goalLabel: '500 kcal',
      data: [320, 480, 410, 620, 540, 710, 460],
    ),
    _MetricConfig(
      label: 'Steps',
      unit: 'k',
      color: Styles.success,
      maxY: 14,
      goalY: 8,
      goalLabel: '8k goal',
      data: [5.2, 7.8, 6.4, 9.5, 8.1, 10.8, 7.2],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final metric = _metrics[_selectedTab];
    final total = metric.data.reduce((a, b) => a + b);
    final totalText = metric.unit == 'k'
        ? '${total.toStringAsFixed(1)}k'
        : '${total.toInt()} ${metric.unit}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: Styles.cardDecoration(withGlow: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(totalText),
          const SizedBox(height: 18),
          _buildMetricSwitcher(),
          const SizedBox(height: 24),
          _buildChart(metric),
        ],
      ),
    );
  }

  Widget _buildHeader(String totalText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weekly Activity',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalText total  •  +12% vs last week',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Styles.warning.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Styles.warning.withValues(alpha: 0.45)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: Styles.warning,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '7-Day Streak',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Styles.warning,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Styles.fieldFill,
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(color: Styles.border),
      ),
      child: Row(
        children: List.generate(_metrics.length, (index) {
          final item = _metrics[index];
          final isSelected = index == _selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                  _touchedIndex = -1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? item.color.withValues(alpha: 0.55)
                        : Colors.transparent,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? item.color
                              : item.color.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Styles.textPrimary
                              : Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChart(_MetricConfig metric) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        height: 195,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: metric.maxY,
            clipData: const FlClipData.none(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: metric.maxY / 4,
              getDrawingHorizontalLine: (_) => const FlLine(
                color: Styles.divider,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: metric.goalY,
                  color: metric.color.withValues(alpha: 0.45),
                  strokeWidth: 1.2,
                  dashArray: [6, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(bottom: 4, right: 2),
                    style: TextStyle(
                      color: metric.color.withValues(alpha: 0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    labelResolver: (_) => metric.goalLabel,
                  ),
                ),
              ],
            ),
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.lineBarSpots == null ||
                      response.lineBarSpots!.isEmpty) {
                    _touchedIndex = -1;
                    return;
                  }
                  _touchedIndex = response.lineBarSpots!.first.x.toInt();
                });
              },
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((_) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: metric.color.withValues(alpha: 0.4),
                      strokeWidth: 1.5,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 6,
                        color: Styles.textPrimary,
                        strokeWidth: 2.5,
                        strokeColor: metric.color,
                      ),
                    ),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipBorderRadius: BorderRadius.circular(10),
                getTooltipColor: (_) => Styles.surfaceElevated,
                tooltipBorder: BorderSide(
                  color: metric.color.withValues(alpha: 0.45),
                  width: 1,
                ),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final day = _days[spot.x.toInt()];
                    final hitGoal = spot.y >= metric.goalY;
                    final valText = metric.unit == 'k'
                        ? '${spot.y.toStringAsFixed(1)}k'
                        : '${spot.y.toStringAsFixed(metric.unit == 'km' ? 1 : 0)} ${metric.unit}';

                    return LineTooltipItem(
                      '$day${hitGoal ? '  •  Goal hit' : ''}\n',
                      const TextStyle(
                        color: Styles.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: valText,
                          style: TextStyle(
                            color: metric.color,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= _days.length) {
                      return const SizedBox();
                    }
                    final isTouched = index == _touchedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _days[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isTouched ? FontWeight.bold : FontWeight.w500,
                          color: isTouched ? metric.color : Styles.textMuted,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                curveSmoothness: 0.35,
                color: metric.color,
                barWidth: 3,
                isStrokeCapRound: true,
                shadow: Shadow(
                  color: metric.color.withValues(alpha: 0.55),
                  blurRadius: 10,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, _, _, _) {
                    final hitGoal = spot.y >= metric.goalY;
                    return FlDotCirclePainter(
                      radius: hitGoal ? 4.5 : 3.5,
                      color: hitGoal ? Styles.textPrimary : Styles.surface,
                      strokeWidth: 2,
                      strokeColor: metric.color,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      metric.color.withValues(alpha: 0.30),
                      Colors.transparent,
                    ],
                  ),
                ),
                spots: List.generate(
                  metric.data.length,
                  (index) => FlSpot(index.toDouble(), metric.data[index]),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
