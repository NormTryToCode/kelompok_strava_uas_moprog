import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

enum RaceElevationProfile { flat, rolling, hilly, mountain }

enum RacePriceTier { free, budget, standard, premium }

class RaceDistanceTier {
  final String id;
  final String label;
  final double distanceKm;
  final int priceIdr;
  final int? elevationGainMeters;
  final String? description;

  const RaceDistanceTier({
    required this.id,
    required this.label,
    required this.distanceKm,
    required this.priceIdr,
    this.elevationGainMeters,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'distanceKm': distanceKm,
        'priceIdr': priceIdr,
        'elevationGainMeters': elevationGainMeters,
        'description': description,
      };

  factory RaceDistanceTier.fromJson(Map<String, dynamic> json) {
    return RaceDistanceTier(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      priceIdr: (json['priceIdr'] as num?)?.toInt() ?? 0,
      elevationGainMeters: (json['elevationGainMeters'] as num?)?.toInt(),
      description: json['description'] as String?,
    );
  }
}

class Race {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final ClubSport sport;
  final String organizerClubId;
  final String organizerName;
  final DateTime startDate;
  final DateTime? endDate;
  final String city;
  final String region;
  final String country;
  final double? latitude;
  final double? longitude;
  final String? coverImageUrl;
  final String? landmarkQuery;
  final String? registrationUrl;
  final List<RaceDistanceTier> distanceTiers;
  final String terrain;
  final RaceElevationProfile elevationProfile;
  final int elevationGainMeters;
  final int avgTemperatureCelsius;
  final String humidityLabel;
  final String windLabel;
  final RacePriceTier priceTier;
  final int minPriceIdr;
  final List<String> tags;
  final int registeredCount;
  final int? maxParticipants;
  final bool isFeatured;
  final bool isRegistered;
  final String? selectedTierId;
  final DateTime createdAt;

  const Race({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.sport,
    required this.organizerClubId,
    required this.organizerName,
    required this.startDate,
    this.endDate,
    required this.city,
    required this.region,
    required this.country,
    this.latitude,
    this.longitude,
    this.coverImageUrl,
    this.landmarkQuery,
    this.registrationUrl,
    required this.distanceTiers,
    this.terrain = 'Road',
    required this.elevationProfile,
    required this.elevationGainMeters,
    required this.avgTemperatureCelsius,
    this.humidityLabel = 'Moderate',
    this.windLabel = 'Light',
    required this.priceTier,
    required this.minPriceIdr,
    this.tags = const [],
    this.registeredCount = 0,
    this.maxParticipants,
    this.isFeatured = false,
    this.isRegistered = false,
    this.selectedTierId,
    required this.createdAt,
  });

  String get locationLabel =>
      region.isEmpty ? '$city, $country' : '$city, $region';

  String get distanceRangeLabel {
    if (distanceTiers.isEmpty) return 'Open Distance';
    if (distanceTiers.length == 1) return distanceTiers.first.label;
    return '${distanceTiers.first.label} - ${distanceTiers.last.label}';
  }

  Race copyWith({
    String? title,
    String? subtitle,
    String? description,
    ClubSport? sport,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImageUrl,
    String? landmarkQuery,
    String? registrationUrl,
    List<RaceDistanceTier>? distanceTiers,
    String? terrain,
    String? humidityLabel,
    String? windLabel,
    int? registeredCount,
    bool? isFeatured,
    bool? isRegistered,
    String? selectedTierId,
    bool clearSelectedTier = false,
  }) {
    return Race(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      sport: sport ?? this.sport,
      organizerClubId: organizerClubId,
      organizerName: organizerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      city: city,
      region: region,
      country: country,
      latitude: latitude,
      longitude: longitude,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      landmarkQuery: landmarkQuery ?? this.landmarkQuery,
      registrationUrl: registrationUrl ?? this.registrationUrl,
      distanceTiers: distanceTiers ?? this.distanceTiers,
      terrain: terrain ?? this.terrain,
      elevationProfile: elevationProfile,
      elevationGainMeters: elevationGainMeters,
      avgTemperatureCelsius: avgTemperatureCelsius,
      humidityLabel: humidityLabel ?? this.humidityLabel,
      windLabel: windLabel ?? this.windLabel,
      priceTier: priceTier,
      minPriceIdr: minPriceIdr,
      tags: tags,
      registeredCount: registeredCount ?? this.registeredCount,
      maxParticipants: maxParticipants,
      isFeatured: isFeatured ?? this.isFeatured,
      isRegistered: isRegistered ?? this.isRegistered,
      selectedTierId:
          clearSelectedTier ? null : (selectedTierId ?? this.selectedTierId),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'sportId': sport.id,
        'organizerClubId': organizerClubId,
        'organizerName': organizerName,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'city': city,
        'region': region,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'coverImageUrl': coverImageUrl,
        'landmarkQuery': landmarkQuery,
        'registrationUrl': registrationUrl,
        'distanceTiers': [for (final tier in distanceTiers) tier.toJson()],
        'terrain': terrain,
        'elevationProfile': elevationProfile.name,
        'elevationGainMeters': elevationGainMeters,
        'avgTemperatureCelsius': avgTemperatureCelsius,
        'humidityLabel': humidityLabel,
        'windLabel': windLabel,
        'priceTier': priceTier.name,
        'minPriceIdr': minPriceIdr,
        'tags': tags,
        'registeredCount': registeredCount,
        'maxParticipants': maxParticipants,
        'isFeatured': isFeatured,
        'isRegistered': isRegistered,
        'selectedTierId': selectedTierId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Race.fromJson(Map<String, dynamic> json) {
    final tiersRaw = json['distanceTiers'] as List? ?? const [];

    return Race(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sport: ClubSport.byId(json['sportId'] as String? ?? 'running'),
      organizerClubId: json['organizerClubId'] as String? ?? '',
      organizerName: json['organizerName'] as String? ?? '',
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
          DateTime(2027, 1, 1),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      city: json['city'] as String? ?? '',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? 'Indonesia',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      coverImageUrl: json['coverImageUrl'] as String?,
      landmarkQuery: json['landmarkQuery'] as String?,
      registrationUrl: json['registrationUrl'] as String?,
      distanceTiers: [
        for (final item in tiersRaw)
          if (item is Map<String, dynamic>) RaceDistanceTier.fromJson(item),
      ],
      terrain: json['terrain'] as String? ?? 'Road',
      elevationProfile: RaceElevationProfile.values.firstWhere(
        (e) => e.name == json['elevationProfile'],
        orElse: () => RaceElevationProfile.flat,
      ),
      elevationGainMeters: (json['elevationGainMeters'] as num?)?.toInt() ?? 0,
      avgTemperatureCelsius:
          (json['avgTemperatureCelsius'] as num?)?.toInt() ?? 26,
      humidityLabel: json['humidityLabel'] as String? ?? 'Moderate',
      windLabel: json['windLabel'] as String? ?? 'Light',
      priceTier: RacePriceTier.values.firstWhere(
        (p) => p.name == json['priceTier'],
        orElse: () => RacePriceTier.standard,
      ),
      minPriceIdr: (json['minPriceIdr'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List?)?.whereType<String>().toList() ?? const [],
      registeredCount: (json['registeredCount'] as num?)?.toInt() ?? 0,
      maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
      isFeatured: json['isFeatured'] as bool? ?? false,
      isRegistered: json['isRegistered'] as bool? ?? false,
      selectedTierId: json['selectedTierId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}