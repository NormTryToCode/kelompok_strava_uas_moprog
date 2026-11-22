import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

class ClubActivity {
  final String id;
  final String clubId;
  final String userId;
  final String athleteName;
  final String title;
  final ClubSport sport;
  final double distanceKm;
  final int movingTimeSeconds;
  final int elevationGainMeters;
  final int kudosCount;
  final bool hasKudos;
  final DateTime recordedAt;

  const ClubActivity({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.athleteName,
    required this.title,
    required this.sport,
    required this.distanceKm,
    required this.movingTimeSeconds,
    this.elevationGainMeters = 0,
    this.kudosCount = 0,
    this.hasKudos = false,
    required this.recordedAt,
  });

  ClubActivity copyWith({
    String? title,
    int? kudosCount,
    bool? hasKudos,
  }) {
    return ClubActivity(
      id: id,
      clubId: clubId,
      userId: userId,
      athleteName: athleteName,
      title: title ?? this.title,
      sport: sport,
      distanceKm: distanceKm,
      movingTimeSeconds: movingTimeSeconds,
      elevationGainMeters: elevationGainMeters,
      kudosCount: kudosCount ?? this.kudosCount,
      hasKudos: hasKudos ?? this.hasKudos,
      recordedAt: recordedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clubId': clubId,
        'userId': userId,
        'athleteName': athleteName,
        'title': title,
        'sportId': sport.id,
        'distanceKm': distanceKm,
        'movingTimeSeconds': movingTimeSeconds,
        'elevationGainMeters': elevationGainMeters,
        'kudosCount': kudosCount,
        'hasKudos': hasKudos,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory ClubActivity.fromJson(Map<String, dynamic> json) {
    return ClubActivity(
      id: json['id'] as String? ?? '',
      clubId: json['clubId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      athleteName: json['athleteName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      sport: ClubSport.byId(json['sportId'] as String? ?? 'running'),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      movingTimeSeconds: (json['movingTimeSeconds'] as num?)?.toInt() ?? 0,
      elevationGainMeters: (json['elevationGainMeters'] as num?)?.toInt() ?? 0,
      kudosCount: (json['kudosCount'] as num?)?.toInt() ?? 0,
      hasKudos: json['hasKudos'] as bool? ?? false,
      recordedAt: DateTime.tryParse(json['recordedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}