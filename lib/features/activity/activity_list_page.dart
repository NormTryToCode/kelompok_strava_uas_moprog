import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/utils/activity_format.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

const double _kmToMiles = 0.621371;

String formatDistanceWithUnit(double km, SettingsDistanceUnit unit) {
  final value = unit == SettingsDistanceUnit.miles ? km * _kmToMiles : km;
  var text = value.toStringAsFixed(2);
  text = text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  return '$text ${unit.abbreviation}';
}

IconData _iconForType(ActivityType type) {
  switch (type) {
    case ActivityType.run:
      return Icons.directions_run;
    case ActivityType.ride:
      return Icons.directions_bike;
    case ActivityType.walk:
      return Icons.directions_walk;
    case ActivityType.swim:
      return Icons.pool;
    case ActivityType.hike:
      return Icons.terrain;
    case ActivityType.workout:
      return Icons.fitness_center;
  }
}

class ActivityListPage extends ConsumerStatefulWidget {
  const ActivityListPage({super.key});

  @override
  ConsumerState<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends ConsumerState<ActivityListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      if (!ref.read(activityProvider).isLoaded) {
        ref.read(activityProvider.notifier).load();
      }
      if (!ref.read(settingsProvider).isLoaded) {
        ref.read(settingsProvider.notifier).load();
      }
    });
  }

  void _openAddActivity() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ManualActivityPage()));
  }

  Future<void> _deleteActivity(ManualActivity activity) async {
    await ref.read(activityProvider.notifier).remove(activity.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Deleted "${activity.title}"')));
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityProvider);
    final unit = ref.watch(settingsProvider).unit;

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: 'My Activities',
        showBackButton: true,
        actions: [
          HeaderIconButton(icon: Icons.add, onPressed: _openAddActivity),
        ],
      ),
      body: activityState.items.isEmpty
          ? _EmptyActivitiesView(onAdd: _openAddActivity)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryBanner(
                  count: activityState.count,
                  totalDistanceText: formatDistanceWithUnit(
                    activityState.totalDistanceKm,
                    unit,
                  ),
                ),
                const SizedBox(height: 16),
                for (final activity in activityState.items)
                  _ActivityCard(
                    activity: activity,
                    unit: unit,
                    onDelete: () => _deleteActivity(activity),
                  ),
              ],
            ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int count;
  final String totalDistanceText;

  const _SummaryBanner({required this.count, required this.totalDistanceText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVITIES',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Styles.primaryLight,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL DISTANCE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalDistanceText,
                  style: const TextStyle(
                    color: Styles.accent,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ManualActivity activity;
  final SettingsDistanceUnit unit;
  final VoidCallback onDelete;

  const _ActivityCard({
    required this.activity,
    required this.unit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pace = activity.pacePerKm;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Styles.accent.withAlpha(40),
                foregroundColor: Styles.accent,
                child: Icon(_iconForType(activity.type), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        color: Styles.primaryLight,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${activity.type.label} • ${formatDate(activity.date)}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete ${activity.title}',
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetricChip(
                label: 'Distance',
                value: formatDistanceWithUnit(activity.distanceKm, unit),
              ),
              const SizedBox(width: 16),
              _MetricChip(
                label: 'Duration',
                value: formatDuration(activity.duration),
              ),
              if (pace != null) ...[
                const SizedBox(width: 16),
                _MetricChip(label: 'Pace', value: formatPace(pace)),
              ],
            ],
          ),
          if (activity.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              activity.notes,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Styles.primaryLight,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EmptyActivitiesView extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyActivitiesView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_run, size: 56, color: Colors.white38),
            const SizedBox(height: 12),
            const Text(
              'No activities yet',
              style: TextStyle(
                color: Styles.primaryLight,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Log your first manual activity to start tracking distance and duration.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Styles.primaryLight,
                shape: const StadiumBorder(),
              ),
              child: const Text('Log Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
