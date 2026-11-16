import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StreakChartWidget extends StatefulWidget {
  const StreakChartWidget({super.key});

  @override
  State<StreakChartWidget> createState() => _StreakChartWidgetState();
}

class _StreakChartWidgetState extends State<StreakChartWidget> {
  final List<double> weeklyData = [
    2, 4, 3, 6, 5, 7, 4
  ];

  final List<String> days = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: 8,
          minY: 0,
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
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
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
                  color: Colors.greenAccent,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 8,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

