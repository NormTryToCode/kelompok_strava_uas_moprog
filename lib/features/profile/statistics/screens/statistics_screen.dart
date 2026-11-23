import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sport_statistics_data.dart';
import '../widgets/statistics_section_table.dart';
import '../widgets/statistics_sport_tab_bar.dart';
import '../widgets/statistics_summary_card.dart';

class StatisticsView extends StatefulWidget {
  final int initialRunSessions;
  final double athleteWeightKg;
  final ValueChanged<int> onRunSessionsChanged;
  final VoidCallback onBack;

  const StatisticsView({
    super.key,
    required this.initialRunSessions,
    required this.athleteWeightKg,
    required this.onRunSessionsChanged,
    required this.onBack,
  });

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  int _selectedSportIndex = 0;
  int _rideSessions = 0;
  late int _runSessions;
  int _swimSessions = 0;

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _runSessions = widget.initialRunSessions;
    _loadSavedSportStats();
  }

  void _loadSavedSportStats() async {
    final int savedRide = await _asyncPrefs.getInt('stats_ride_sessions') ?? 0;
    final int savedSwim = await _asyncPrefs.getInt('stats_swim_sessions') ?? 0;
    if (!mounted) return;
    setState(() {
      _rideSessions = savedRide;
      _swimSessions = savedSwim;
    });
  }

  void _updateCurrentSportSessions(int newCount) async {
    final int clamped = newCount < 0 ? 0 : newCount;
    setState(() {
      if (_selectedSportIndex == 0) {
        _rideSessions = clamped;
      } else if (_selectedSportIndex == 1) {
        _runSessions = clamped;
      } else {
        _swimSessions = clamped;
      }
    });

    if (_selectedSportIndex == 0) {
      await _asyncPrefs.setInt('stats_ride_sessions', clamped);
    } else if (_selectedSportIndex == 1) {
      widget.onRunSessionsChanged(clamped);
    } else {
      await _asyncPrefs.setInt('stats_swim_sessions', clamped);
    }
  }

  int get _activeSessionCount {
    if (_selectedSportIndex == 0) return _rideSessions;
    if (_selectedSportIndex == 1) return _runSessions;
    return _swimSessions;
  }

  @override
  Widget build(BuildContext context) {
    final stats = SportStatisticsData(
      sportIndex: _selectedSportIndex,
      weeklySessions: _activeSessionCount,
      historicalBaseSessions: (_selectedSportIndex == 0)
          ? 6
          : (_selectedSportIndex == 1)
          ? 10
          : 4,
      athleteWeightKg: widget.athleteWeightKg,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(Icons.arrow_back, color: Styles.primaryLight),
              ),
              const SizedBox(width: 24),
              const Text(
                'Statistik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.primaryLight,
                ),
              ),
            ],
          ),
        ),
        StatisticsSportTabBar(
          activeSportIndex: _selectedSportIndex,
          onSelectSport: (int index) {
            setState(() {
              _selectedSportIndex = index;
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatisticsSummaryCard(
                  stats: stats,
                  onDecrement: () =>
                      _updateCurrentSportSessions(_activeSessionCount - 1),
                  onReset: () => _updateCurrentSportSessions(0),
                  onIncrement: () =>
                      _updateCurrentSportSessions(_activeSessionCount + 1),
                ),
                StatisticsSectionTable(
                  sectionTitle: 'AKTIVITAS MINGGUAN RATA2',
                  items: [
                    StatisticMetricItem(
                      label: stats.sportLabel,
                      value: stats.weeklyActivityCount,
                    ),
                    StatisticMetricItem(
                      label: 'Waktu',
                      value: stats.weeklyDurationText,
                    ),
                    StatisticMetricItem(
                      label: 'Jarak',
                      value: stats.weeklyDistanceText,
                    ),
                  ],
                ),
                StatisticsSectionTable(
                  sectionTitle: 'SETAHUN INI',
                  items: [
                    StatisticMetricItem(
                      label: stats.sportLabel,
                      value: stats.yearlyActivityCount,
                    ),
                    StatisticMetricItem(
                      label: 'Waktu',
                      value: stats.yearlyDurationText,
                    ),
                    StatisticMetricItem(
                      label: 'Jarak',
                      value: stats.yearlyDistanceText,
                    ),
                    if (stats.hasElevation)
                      StatisticMetricItem(
                        label: 'Kenaikan Elevasi',
                        value: stats.yearlyElevationText,
                      ),
                  ],
                ),
                StatisticsSectionTable(
                  sectionTitle: 'SEPANJANG WAKTU',
                  items: [
                    StatisticMetricItem(
                      label: stats.sportLabel,
                      value: stats.allTimeActivityCount,
                    ),
                    StatisticMetricItem(
                      label: 'Jarak',
                      value: stats.allTimeDistanceText,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

