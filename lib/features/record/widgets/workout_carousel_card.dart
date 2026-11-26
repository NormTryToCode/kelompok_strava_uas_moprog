import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/workout_series_model.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/workout_figure_animation.dart';

/// Carousel card with ~65% animated exercise visual and ~35% title, metadata, and Play CTA.
class WorkoutCarouselCard extends StatelessWidget {
  final WorkoutSessionModel workout;
  final int index;
  final int total;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  const WorkoutCarouselCard({
    super.key,
    required this.workout,
    required this.index,
    required this.total,
    required this.onTap,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: 274,
      decoration: Styles.cardDecoration(radius: Radii.card, withGlow: true),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.card),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 65,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      WorkoutFigureAnimation(motion: workout.motion),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Styles.surface.withValues(alpha: 0.92),
                            ],
                            stops: const [0.65, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Styles.canvas.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(Radii.chip),
                            border: Border.all(
                              color: Styles.borderGlow.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '${index + 1} / $total',
                            style: const TextStyle(
                              color: Styles.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 35,
                  child: Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Styles.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                workout.metadataLine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Styles.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Semantics(
                          button: true,
                          label: 'Play ${workout.title}',
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: Styles.primaryGradient,
                              boxShadow: Styles.glow(
                                intensity: 0.42,
                                blur: 14,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: onPlay,
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Styles.textPrimary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
