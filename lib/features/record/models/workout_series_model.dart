/// Supported procedural exercise animations for strength workout cards.
enum WorkoutExerciseMotion {
  fullBody,
  lowerBody,
  upperBody,
  core,
}

/// Immutable data model representing an individual guided workout session.
class WorkoutSessionModel {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String difficulty;
  final String summary;
  final List<String> targetMuscles;
  final WorkoutExerciseMotion motion;

  const WorkoutSessionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.summary,
    required this.targetMuscles,
    required this.motion,
  });

  /// Formatted metadata line such as `Weight Training · 20m · Easy`.
  String get metadataLine => '$category \u00B7 $duration \u00B7 $difficulty';
}

/// Immutable data model representing a themed collection of workouts.
class WorkoutSeriesModel {
  final String id;
  final String title;
  final String description;
  final List<WorkoutSessionModel> workouts;

  const WorkoutSeriesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.workouts,
  });
}

/// Local catalog of guided workout series displayed on the Record tab.
class RecordWorkoutCatalog {
  RecordWorkoutCatalog._();

  static const WorkoutSeriesModel strengthIntroSeries = WorkoutSeriesModel(
    id: 'strength-intro-series',
    title: 'Strength intro series',
    description:
        'Build the foundations of strength training across 4 easy-to-follow workouts, gaining confidence and momentum with every session.',
    workouts: [
      WorkoutSessionModel(
        id: 'full-body',
        title: 'Full body',
        category: 'Weight Training',
        duration: '20m',
        difficulty: 'Easy',
        summary:
            'Coordinate compound squat-to-press movements to wake up major muscle groups and build steady total-body control.',
        targetMuscles: ['Quads', 'Glutes', 'Shoulders', 'Core'],
        motion: WorkoutExerciseMotion.fullBody,
      ),
      WorkoutSessionModel(
        id: 'lower-body',
        title: 'Lower body',
        category: 'Weight Training',
        duration: '20m',
        difficulty: 'Easy',
        summary:
            'Strengthen your stride and knee stability with controlled split lunges and balanced lower-body fundamentals.',
        targetMuscles: ['Quads', 'Hamstrings', 'Glutes', 'Calves'],
        motion: WorkoutExerciseMotion.lowerBody,
      ),
      WorkoutSessionModel(
        id: 'upper-body',
        title: 'Upper body',
        category: 'Weight Training',
        duration: '20m',
        difficulty: 'Easy',
        summary:
            'Develop confident overhead pressing mechanics and upper-back posture with light, rhythmic dumbbell sets.',
        targetMuscles: ['Shoulders', 'Chest', 'Triceps', 'Upper Back'],
        motion: WorkoutExerciseMotion.upperBody,
      ),
      WorkoutSessionModel(
        id: 'core',
        title: 'Core',
        category: 'Weight Training',
        duration: '20m',
        difficulty: 'Easy',
        summary:
            'Reinforce trunk stability and breathing rhythm through controlled mat tucks that support every run and ride.',
        targetMuscles: ['Abs', 'Obliques', 'Lower Back', 'Hip Flexors'],
        motion: WorkoutExerciseMotion.core,
      ),
    ],
  );
}
