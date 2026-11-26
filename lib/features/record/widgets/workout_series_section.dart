import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/workout_series_model.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/workout_carousel_card.dart';

/// Section displaying a workout series title, description, and horizontal card carousel.
class WorkoutSeriesSection extends StatelessWidget {
  final WorkoutSeriesModel series;
  final VoidCallback onSeriesTap;
  final ValueChanged<WorkoutSessionModel> onWorkoutTap;
  final ValueChanged<WorkoutSessionModel> onWorkoutPlay;

  const WorkoutSeriesSection({
    super.key,
    required this.series,
    required this.onSeriesTap,
    required this.onWorkoutTap,
    required this.onWorkoutPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(Radii.chip),
                onTap: onSeriesTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        series.title,
                        style: const TextStyle(
                          color: Styles.textPrimary,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Styles.primaryLight,
                        size: 22,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Styles.surfaceHighlight,
                          borderRadius: BorderRadius.circular(Radii.chip),
                          border: Border.all(color: Styles.borderStrong),
                        ),
                        child: Text(
                          '${series.workouts.length} workouts',
                          style: const TextStyle(
                            color: Styles.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 274,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: series.workouts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final workout = series.workouts[index];
              return WorkoutCarouselCard(
                workout: workout,
                index: index,
                total: series.workouts.length,
                onTap: () => onWorkoutTap(workout),
                onPlay: () => onWorkoutPlay(workout),
              );
            },
          ),
        ),
      ],
    );
  }
}
