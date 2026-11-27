import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/home/models/weekly_activity_model.dart';
import 'package:kelompok_strava_uas_moprog/features/home/providers/weekly_activity_provider.dart';

class _MetricConfig {
  final String label;
  final String unit;
  final String totalText;
  final Color color;
  final double maxY;
  final double goalY;
  final String goalLabel;
  final List<double> data;

  const _MetricConfig({
    required this.label,
    required this.unit,
    required this.totalText,
    required this.color,
    required this.maxY,
    required this.goalY,
    required this.goalLabel,
    required this.data,
  });
}

class StreakChartWidget extends ConsumerStatefulWidget {
  const StreakChartWidget({super.key});

  @override
  ConsumerState<StreakChartWidget> createState() => _StreakChartWidgetState();
}

class _StreakChartWidgetState extends ConsumerState<StreakChartWidget> {
  int _selectedTab = 0;
  int _touchedIndex = -1;

  List<_MetricConfig> _buildMetrics(WeeklyActivityData week) {
    final distData = week.distanceSeries;
    final distMaxVal = distData.fold<double>(5.0, math.max);
    final distMaxY = math.max(10.0, (distMaxVal * 1.25).ceilToDouble());

    final calData = week.caloriesSeries;
    final calMaxVal = calData.fold<double>(500.0, math.max);
    final calMaxY = math.max(900.0, ((calMaxVal * 1.25) / 100).ceil() * 100.0);

    final stepData = week.stepsThousandsSeries;
    final stepMaxVal = stepData.fold<double>(8.0, math.max);
    final stepMaxY = math.max(14.0, (stepMaxVal * 1.2).ceilToDouble());

    return [
      _MetricConfig(
        label: 'Distance',
        unit: 'km',
        totalText: '${week.totalDistanceKm.toStringAsFixed(1)} km',
        color: Styles.primary,
        maxY: distMaxY,
        goalY: 5,
        goalLabel: '5 km goal',
        data: distData,
      ),
      _MetricConfig(
        label: 'Calories',
        unit: 'kcal',
        totalText: '${week.totalCalories} kcal',
        color: Styles.danger,
        maxY: calMaxY,
        goalY: 500,
        goalLabel: '500 kcal',
        data: calData,
      ),
      _MetricConfig(
        label: 'Steps',
        unit: 'k',
        totalText: week.totalSteps >= 1000
            ? '${week.totalStepsInThousands.toStringAsFixed(1)}k'
            : '${week.totalSteps}',
        color: Styles.success,
        maxY: stepMaxY,
        goalY: 8,
        goalLabel: '8k goal',
        data: stepData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final weeklyState = ref.watch(weeklyActivityProvider);
    final week = weeklyState.week;
    final dayLabels = [for (final d in week.days) d.dayLabel];
    final metrics = _buildMetrics(week);
    final metric = metrics[_selectedTab];
    final goalsHit = metric.data.where((v) => v >= metric.goalY).length;
    final badgeText = (weeklyState.isLoading && !weeklyState.isLoaded)
        ? 'Syncing...'
        : '$goalsHit/7 goals';
    final streakDays = week.activeDaysCount;

    return Container(
      decoration: Styles.cardDecoration(
        withGlow: true,
        borderColor: Styles.borderStrong,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: Styles.radialGlow(
                    color: metric.color,
                    intensity: 0.18,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  totalText: metric.totalText,
                  badgeText: badgeText,
                  streakDays: streakDays,
                ),
                const SizedBox(height: 16),
                _buildMetricSwitcher(metrics),
                const SizedBox(height: 22),
                _buildChart(metric, dayLabels),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required String totalText,
    required String badgeText,
    required int streakDays,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WEEKLY ACTIVITY',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                  color: Styles.primaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      totalText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.success.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Styles.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Styles.warning.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Styles.warning.withValues(alpha: 0.45)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Styles.warning,
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                '$streakDays-Day Streak',
                style: const TextStyle(
                  fontSize: 11.5,
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

  Widget _buildMetricSwitcher(List<_MetricConfig> metrics) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(color: Styles.border),
      ),
      child: Row(
        children: List.generate(metrics.length, (index) {
          final item = metrics[index];
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
                      ? Styles.surfaceHighlight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? item.color.withValues(alpha: 0.5)
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

  Widget _buildChart(_MetricConfig metric, List<String> dayLabels) {
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
                    final dayIndex =
                        spot.x.toInt().clamp(0, dayLabels.length - 1);
                    final day = dayLabels[dayIndex];
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
                    if (index < 0 || index >= dayLabels.length) {
                      return const SizedBox();
                    }
                    final isTouched = index == _touchedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        dayLabels[index],
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
