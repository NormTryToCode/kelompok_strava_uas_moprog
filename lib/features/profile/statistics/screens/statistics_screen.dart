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
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 10.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Styles.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Styles.borderStrong),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Styles.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Lab',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    Text(
                      'Multi-Sport Telemetry & Targets',
                      style: TextStyle(
                        fontSize: 12,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
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
                  sectionTitle: 'WEEKLY CADENCE',
                  items: [
                    StatisticMetricItem(
                      label: 'Weekly ${stats.sessionPluralLabel}',
                      value: stats.weeklyActivityCount,
                      icon: Icons.repeat_rounded,
                    ),
                    StatisticMetricItem(
                      label: 'Active Time',
                      value: stats.weeklyDurationText,
                      icon: Icons.timer_outlined,
                    ),
                    StatisticMetricItem(
                      label: 'Weekly Distance',
                      value: stats.weeklyDistanceText,
                      icon: Icons.straighten_rounded,
                      highlight: true,
                    ),
                  ],
                ),
                StatisticsSectionTable(
                  sectionTitle: 'SEASON TO DATE',
                  items: [
                    StatisticMetricItem(
                      label: 'Season ${stats.sessionPluralLabel}',
                      value: stats.yearlyActivityCount,
                      icon: Icons.calendar_month_rounded,
                    ),
                    StatisticMetricItem(
                      label: 'Total Duration',
                      value: stats.yearlyDurationText,
                      icon: Icons.schedule_rounded,
                    ),
                    StatisticMetricItem(
                      label: 'Season Volume',
                      value: stats.yearlyDistanceText,
                      icon: Icons.trending_up_rounded,
                      highlight: true,
                    ),
                    if (stats.hasElevation)
                      StatisticMetricItem(
                        label: 'Elevation Gain',
                        value: stats.yearlyElevationText,
                        icon: Icons.terrain_rounded,
                      ),
                  ],
                ),
                StatisticsSectionTable(
                  sectionTitle: 'LIFETIME CAREER',
                  items: [
                    StatisticMetricItem(
                      label: 'All-Time ${stats.sessionPluralLabel}',
                      value: stats.allTimeActivityCount,
                      icon: Icons.workspace_premium_rounded,
                    ),
                    StatisticMetricItem(
                      label: 'Lifetime Volume',
                      value: stats.allTimeDistanceText,
                      icon: Icons.public_rounded,
                      highlight: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}