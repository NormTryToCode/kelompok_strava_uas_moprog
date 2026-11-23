import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StreakChartWidget extends StatefulWidget {
  const StreakChartWidget({super.key});

  @override
  State<StreakChartWidget> createState() => _StreakChartWidgetState();
}

class _StreakChartWidgetState extends State<StreakChartWidget> {
  final List<double> weeklyData = [2, 4, 3, 6, 5, 7, 4];

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Weekly Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Styles.primaryDark,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: 8,
              minY: 0,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()} km',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
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
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 || index >= days.length) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          days[index],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Styles.primaryDark,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(
                weeklyData.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: weeklyData[index],
                      width: 16,
                      borderRadius: BorderRadius.circular(6),
                      color: Styles.primaryDark,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 8,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
