import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
      color: Colors.cyanAccent,
      maxY: 8,
      goalY: 5,
      goalLabel: '5 km goal',
      data: [2, 4, 3, 6, 5, 7, 4],
    ),
    _MetricConfig(
      label: 'Calories',
      unit: 'kcal',
      color: Colors.redAccent,
      maxY: 800,
      goalY: 500,
      goalLabel: '500 kcal',
      data: [320, 480, 410, 620, 540, 710, 460],
    ),
    _MetricConfig(
      label: 'Steps',
      unit: 'k',
      color: Colors.amber,
      maxY: 12,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(totalText),
          const SizedBox(height: 18),
          _buildMetricSwitcher(),
          const SizedBox(height: 28),
          _buildChart(metric),
        ],
      ),
    );
  }

  Widget _buildHeader(String totalText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Activity',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalText total  •  +12% vs last week',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepOrange.withOpacity(0.5)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: Colors.deepOrangeAccent,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '7-Day Streak',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
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
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withOpacity(0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: isSelected
                        ? item.color.withOpacity(0.55)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.color
                            : item.color.withOpacity(0.55),
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
                        color: isSelected ? Colors.white : Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChart(_MetricConfig metric) {
    return SizedBox(
      height: 195,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: metric.maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: metric.maxY / 4,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Colors.white10,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: metric.goalY,
                color: metric.color.withOpacity(0.45),
                strokeWidth: 1.2,
                dashArray: [6, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(bottom: 4, right: 2),
                  style: TextStyle(
                    color: metric.color.withOpacity(0.85),
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
                    color: metric.color.withOpacity(0.4),
                    strokeWidth: 1.5,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 2.5,
                      strokeColor: metric.color,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(10),
              getTooltipColor: (_) => Colors.grey[850]!,
              tooltipBorder: BorderSide(
                color: metric.color.withOpacity(0.45),
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
                      color: Colors.white70,
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
                        color: isTouched ? metric.color : Colors.white54,
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
                color: metric.color.withOpacity(0.6),
                blurRadius: 10,
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, ___) {
                  final hitGoal = spot.y >= metric.goalY;
                  return FlDotCirclePainter(
                    radius: hitGoal ? 4.5 : 3.5,
                    color: hitGoal ? Colors.white : Colors.grey[900]!,
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
                    metric.color.withOpacity(0.32),
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
    );
  }
}
