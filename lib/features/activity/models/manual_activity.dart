enum ActivityType {
  run('Run'),
  ride('Ride'),
  walk('Walk'),
  swim('Swim'),
  hike('Hike'),
  workout('Workout');

  final String label;

  const ActivityType(this.label);
}

class ManualActivity {
  final String id;
  final String title;
  final ActivityType type;
  final DateTime date;
  final Duration duration;
  final double distanceKm;
  final String notes;

  const ManualActivity({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.duration,
    required this.distanceKm,
    this.notes = '',
  });

  double get averageSpeedKmh {
    final hours = duration.inSeconds / 3600;
    return hours == 0 ? 0 : distanceKm / hours;
  }

  Duration? get pacePerKm {
    if (distanceKm <= 0) return null;
    return Duration(seconds: (duration.inSeconds / distanceKm).round());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'date': date.toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'distanceKm': distanceKm,
      'notes': notes,
    };
  }

  factory ManualActivity.fromJson(Map<String, dynamic> json) {
    return ManualActivity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: ActivityType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => ActivityType.workout,
      ),
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      duration: Duration(
        seconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      ),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? '',
    );
  }
}