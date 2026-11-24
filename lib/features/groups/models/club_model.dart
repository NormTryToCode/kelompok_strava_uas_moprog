import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

class Club {
  final String id;
  final String name;
  final String description;
  final ClubSport sport;
  final List<ClubType> types;
  final ClubPrivacy privacy;
  final bool isGlobal;
  final ClubLocation? location;
  final String? avatarPath;
  final String? coverPath;
  final String? vanityUrl;
  final int memberCount;
  final bool isOwner;
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
    this.isOwner = true,
    this.avatarPath,
    this.coverPath,
    this.vanityUrl,
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
      isOwner: true,
      createdAt: now,
    );
  }

  factory Club.fromSearchClub(SearchClub source) {
    return Club(
      id: source.id,
      name: source.name,
      description:
          'Community ${source.sport.label.toLowerCase()} club based in ${source.city}.',
      sport: ClubSport.byId(source.sport.name),
      types: [ClubType.option.last],
      privacy: ClubPrivacy.public,
      isGlobal: false,
      location: ClubLocation(name: source.city),
      memberCount: source.memberCount + 1,
      isOwner: false,
      createdAt: DateTime.now(),
    );
  }

  String get memberLabel {
    if (memberCount >= 1000000) {
      return '${(memberCount / 1000000).toStringAsFixed(1)}M Members';
    }
    if (memberCount >= 1000) {
      return '${(memberCount / 1000).toStringAsFixed(1)}K Members';
    }
    return memberCount == 1 ? '1 Member' : '$memberCount Members';
  }

  String get typeLabel => types.map((t) => t.name).join(' \u00b7 ');

  String get locationLabel => isGlobal || location == null
      ? 'Global'
      : location!.detail.isEmpty
          ? location!.name
          : '${location!.name}, ${location!.detail}';

  Club copyWith({
    String? id,
    String? name,
    String? description,
    ClubSport? sport,
    List<ClubType>? types,
    ClubPrivacy? privacy,
    bool? isGlobal,
    ClubLocation? location,
    bool clearLocation = false,
    String? avatarPath,
    bool clearAvatar = false,
    String? coverPath,
    bool clearCover = false,
    String? vanityUrl,
    bool clearVanityUrl = false,
    int? memberCount,
    bool? isOwner,
    DateTime? createdAt,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sport: sport ?? this.sport,
      types: types ?? this.types,
      privacy: privacy ?? this.privacy,
      isGlobal: isGlobal ?? this.isGlobal,
      location: clearLocation ? null : (location ?? this.location),
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      coverPath: clearCover ? null : (coverPath ?? this.coverPath),
      vanityUrl: clearVanityUrl ? null : (vanityUrl ?? this.vanityUrl),
      memberCount: memberCount ?? this.memberCount,
      isOwner: isOwner ?? this.isOwner,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      'avatarPath': avatarPath,
      'coverPath': coverPath,
      'vanityUrl': vanityUrl,
      'memberCount': memberCount,
      'isOwner': isOwner,
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
      avatarPath: json['avatarPath'] as String?,
      coverPath: json['coverPath'] as String?,
      vanityUrl: json['vanityUrl'] as String?,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
      isOwner: json['isOwner'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}