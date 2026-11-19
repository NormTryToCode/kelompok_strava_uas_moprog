import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';

class Club {
  final String id;
  final String name;
  final String description;
  final ClubSport sport;
  final List<ClubType> types;
  final ClubPrivacy privacy;
  final bool isGlobal;
  final ClubLocation? location;
  final int memberCount;
  final DateTime createdAt;

  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.types,
    required this.privacy,
    required this.isGlobal,
    required this.location,
    required this.memberCount,
    required this.createdAt,
  });

  factory Club.fromCreation(ClubCreationModel draft) {
    final now = DateTime.now();
    return Club(
      id: now.microsecondsSinceEpoch.toString(),
      name: draft.name.trim(),
      description: draft.description.trim(),
      sport: draft.sport,
      types: draft.types,
      privacy: draft.privacy,
      isGlobal: draft.isGlobal,
      location: draft.isGlobal ? null : draft.location,
      memberCount: 1,
      createdAt: now,
    );
  }

  String get memberLabel =>
      memberCount == 1 ? '1 Member' : '$memberCount Members';

  String get typeLabel => types.map((t) => t.name).join(' \u00b7 ');

  Map<String, dynamic> toJson() {
    final place = location;
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport.id,
      'types': types.map((t) => t.id).toList(),
      'privacy': privacy.id,
      'isGlobal': isGlobal,
      'location': place == null
          ? null
          : {
              'name': place.name,
              'detail': place.detail,
              'latitude': place.latitude,
              'longitude': place.longitude,
            },
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Club.fromJson(Map<String, dynamic> json) {
    final typeIds =
        (json['types'] as List?)?.whereType<String>().toSet() ?? <String>{};
    final place = json['location'];

    return Club(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sport: ClubSport.option.firstWhere(
        (s) => s.id == json['sport'],
        orElse: () => ClubSport.allSports,
      ),
      types: ClubType.option.where((t) => typeIds.contains(t.id)).toList(),
      privacy: ClubPrivacy.option.firstWhere(
        (p) => p.id == json['privacy'],
        orElse: () => ClubPrivacy.public,
      ),
      isGlobal: json['isGlobal'] as bool? ?? true,
      location: place is Map
          ? ClubLocation(
              name: place['name'] as String? ?? '',
              detail: place['detail'] as String? ?? '',
              latitude: (place['latitude'] as num?)?.toDouble(),
              longitude: (place['longitude'] as num?)?.toDouble(),
            )
          : null,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
