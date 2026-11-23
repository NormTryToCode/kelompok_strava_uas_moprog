import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../edit_profile/providers/athlete_profile_provider.dart';
import '../models/sport_statistics_data.dart';
import '../providers/sport_statistics_provider.dart';
import '../widgets/statistics_section_table.dart';
import '../widgets/statistics_sport_tab_bar.dart';
import '../widgets/statistics_summary_card.dart';

class StatisticsView extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const StatisticsView({
    super.key,
    required this.onBack,
  });

  @override
  ConsumerState<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends ConsumerState<StatisticsView> {
  int _selectedSportIndex = 0;

  @override
  Widget build(BuildContext context) {
    final SportSessionsState sessionsState = ref.watch(sportStatisticsProvider);
    final double athleteWeightKg =
        ref.watch(athleteProfileProvider).parsedWeightKg;
    final int activeSessionCount =
        sessionsState.sessionsForSport(_selectedSportIndex);

    final stats = SportStatisticsData(
      sportIndex: _selectedSportIndex,
      weeklySessions: activeSessionCount,
      historicalBaseSessions: (_selectedSportIndex == 0)
        ? 6
        : (_selectedSportIndex == 1)
          ? 10
          : 4,
      athleteWeightKg: athleteWeightKg,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(width: 24),
              const Text(
                'Statistik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.textPrimary,
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
                  onDecrement: () => ref
                    .read(sportStatisticsProvider.notifier)
                    .setSportSessions(
                      _selectedSportIndex,
                      activeSessionCount - 1,
                    ),
                  onReset: () => ref
                    .read(sportStatisticsProvider.notifier)
                    .setSportSessions(_selectedSportIndex, 0),
                  onIncrement: () => ref
                    .read(sportStatisticsProvider.notifier)
                    .setSportSessions(
                      _selectedSportIndex,
                      activeSessionCount + 1,
                    ),
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