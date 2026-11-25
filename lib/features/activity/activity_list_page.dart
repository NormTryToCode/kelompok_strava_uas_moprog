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
  ActivityType? _selectedType;

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
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ManualActivityPage()),
    );
  }

  void _openEditActivity(ManualActivity activity) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManualActivityPage(existing: activity),
      ),
    );
  }

  Future<void> _deleteActivity(ManualActivity activity) async {
    final notifier = ref.read(activityProvider.notifier);
    await notifier.remove(activity.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted "${activity.title}"'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => notifier.add(activity),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityProvider);
    final unit = ref.watch(settingsProvider).unit;
    final filtered = _selectedType == null
        ? activityState.items
        : activityState.items
            .where((item) => item.type == _selectedType)
            .toList(growable: false);
    final totalKm = filtered.fold<double>(
      0,
      (sum, item) => sum + item.distanceKm,
    );

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: 'My Activities',
        showBackButton: true,
        actions: [
          HeaderIconButton(
            icon: Icons.add,
            onPressed: _openAddActivity,
          ),
        ],
      ),
      body: activityState.items.isEmpty
          ? _EmptyActivitiesView(onAdd: _openAddActivity)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SummaryBanner(
                  count: filtered.length,
                  totalDistanceText: formatDistanceWithUnit(totalKm, unit),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedType == null,
                          selectedColor: Styles.primary,
                          backgroundColor: Styles.surface,
                          labelStyle: TextStyle(
                            color: _selectedType == null
                                ? Styles.textPrimary
                                : Styles.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedType = null),
                        ),
                      ),
                      for (final type in ActivityType.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type.label),
                            selected: _selectedType == type,
                            selectedColor: Styles.primary,
                            backgroundColor: Styles.surface,
                            labelStyle: TextStyle(
                              color: _selectedType == type
                                  ? Styles.textPrimary
                                  : Styles.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            onSelected: (_) =>
                                setState(() => _selectedType = type),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No activities match this sport filter.',
                        style: TextStyle(
                          color: Styles.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                else
                  for (final activity in filtered)
                    _ActivityCard(
                      activity: activity,
                      unit: unit,
                      onTap: () => _openEditActivity(activity),
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

  const _SummaryBanner({
    required this.count,
    required this.totalDistanceText,
  });

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
                    color: Styles.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Styles.textPrimary,
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
                    color: Styles.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalDistanceText,
                  style: const TextStyle(
                    color: Styles.primaryLight,
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
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ActivityCard({
    required this.activity,
    required this.unit,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pace = activity.pacePerKm;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
                    backgroundColor: Styles.surfaceHighlight,
                    foregroundColor: Styles.primaryLight,
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
                            color: Styles.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${activity.type.label} • ${formatDate(activity.date)}',
                          style: const TextStyle(
                            color: Styles.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete ${activity.title}',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Styles.textSecondary,
                    ),
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
                  style: const TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
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
          style: const TextStyle(color: Styles.textSecondary, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Styles.textPrimary,
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
            const Icon(
              Icons.directions_run,
              size: 56,
              color: Styles.textMuted,
            ),
            const SizedBox(height: 12),
            const Text(
              'No activities yet',
              style: TextStyle(
                color: Styles.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Log your first manual activity to start tracking distance and duration.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Styles.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.primary,
                foregroundColor: Styles.textPrimary,
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