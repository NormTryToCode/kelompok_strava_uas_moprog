import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/workout_series_model.dart';
import 'package:kelompok_strava_uas_moprog/features/record/providers/record_sport_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/record/record_track.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/record_action_card_button.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/sport_filter_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/workout_figure_animation.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/workout_series_section.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

/// Main Record tab layout featuring quick-start sport cards and guided strength series.
class RecordWidget extends ConsumerWidget {
  const RecordWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Record',
        actions: [
          HeaderIconButton(
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchPage()),
            ),
          ),
          HeaderIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      backgroundColor: Styles.canvas,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecordActionCardButton(
                    action: 'Walk',
                    onTap: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Walk',
                      autoStart: false,
                    ),
                    onStart: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Walk',
                      autoStart: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RecordActionCardButton(
                    action: 'Run',
                    onTap: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Run',
                      autoStart: false,
                    ),
                    onStart: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Run',
                      autoStart: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RecordActionCardButton(
                    action: 'Ride',
                    onTap: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Ride',
                      autoStart: false,
                    ),
                    onStart: () => _openRecordTrack(
                      context,
                      ref,
                      action: 'Ride',
                      autoStart: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _SecondaryActionPill(
                          icon: Icons.grid_view_rounded,
                          label: 'More sports',
                          backgroundColor: Styles.surfaceElevated,
                          borderColor: Styles.borderStrong,
                          foregroundColor: Styles.primaryLight,
                          onTap: () => _openMoreSportsFilter(context, ref),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SecondaryActionPill(
                          icon: Icons.edit_note,
                          label: 'Log Manual Activity',
                          backgroundColor: Styles.surface,
                          borderColor: Styles.border,
                          foregroundColor: Styles.textPrimary,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ManualActivityPage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            WorkoutSeriesSection(
              series: RecordWorkoutCatalog.strengthIntroSeries,
              onSeriesTap: () => _showSeriesOverviewSheet(
                context,
                RecordWorkoutCatalog.strengthIntroSeries,
              ),
              onWorkoutTap: (workout) =>
                  _showWorkoutPreviewSheet(context, workout),
              onWorkoutPlay: (workout) => _showFeedback(
                context,
                'Starting ${workout.title} (${workout.duration})...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRecordTrack(
    BuildContext context,
    WidgetRef ref, {
    required String action,
    required bool autoStart,
  }) {
    ref.read(selectedRecordSportProvider.notifier).selectByName(action);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecordTrackPage(
          initialSportName: action,
          autoStart: autoStart,
        ),
      ),
    );
  }

  Future<void> _openMoreSportsFilter(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentSport = ref.read(selectedRecordSportProvider);
    final chosen = await showSportFilterSheet(
      context,
      selectedSport: currentSport,
    );
    if (chosen == null || !context.mounted) return;
    ref.read(selectedRecordSportProvider.notifier).select(chosen);
    _openRecordTrack(
      context,
      ref,
      action: chosen.name,
      autoStart: false,
    );
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Styles.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.chip),
            side: const BorderSide(color: Styles.borderGlow),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Styles.textPrimary),
          ),
        ),
      );
  }

  void _showWorkoutPreviewSheet(
    BuildContext context,
    WorkoutSessionModel workout,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Styles.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.card),
                  child: SizedBox(
                    height: 180,
                    child: WorkoutFigureAnimation(motion: workout.motion),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  workout.title,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workout.metadataLine,
                  style: const TextStyle(
                    color: Styles.primaryLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  workout.summary,
                  style: const TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: workout.targetMuscles
                      .map(
                        (muscle) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Styles.surfaceHighlight,
                            borderRadius: BorderRadius.circular(Radii.chip),
                            border: Border.all(color: Styles.borderStrong),
                          ),
                          child: Text(
                            muscle,
                            style: const TextStyle(
                              color: Styles.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 46,
                  decoration: Styles.buttonDecoration(
                    radius: Radii.button,
                    withGlow: true,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.button),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _showFeedback(
                          context,
                          'Starting ${workout.title} (${workout.duration})...',
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Styles.textPrimary,
                              size: 22,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Start Workout',
                              style: TextStyle(
                                color: Styles.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSeriesOverviewSheet(
    BuildContext context,
    WorkoutSeriesModel series,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.card)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Styles.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  series.title,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  series.description,
                  style: const TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                ...series.workouts.map(
                  (workout) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: Styles.cardDecoration(radius: Radii.field),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        title: Text(
                          workout.title,
                          style: const TextStyle(
                            color: Styles.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          workout.metadataLine,
                          style: const TextStyle(
                            color: Styles.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Styles.primaryLight,
                            size: 32,
                          ),
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            _showFeedback(
                              context,
                              'Starting ${workout.title} (${workout.duration})...',
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          _showWorkoutPreviewSheet(context, workout);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SecondaryActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _SecondaryActionPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Radii.button),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.button),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
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
