import 'package:flutter/material.dart';

class ClubSport {
  final String id;
  final String name;
  final IconData icon;
  final String? subsports;

  const ClubSport({
    required this.id,
    required this.name,
    required this.icon,
    this.subsports,
  });

  static const allSports = ClubSport(
    id: 'all',
    name: 'All Sports',
    icon: Icons.layers_outlined,
  );

  static const option = <ClubSport>[
    allSports,
    ClubSport(
      id: 'cycling',
      name: 'Cycling',
      icon: Icons.directions_bike,
      subsports:
          'Handcycle, E-Bike Ride, Gravel Ride, Virtual Ride, Velomobile, Mountain Bike Ride, E-Mountain Bike Ride, Ride',
    ),
    ClubSport(
      id: 'running',
      name: 'Running',
      icon: Icons.directions_run,
      subsports: 'Run, Virtual Run, Wheelchair, Trail Run',
    ),
    ClubSport(
      id: 'triathlon',
      name: 'Triathlon',
      icon: Icons.pool,
      subsports: 'All Run, All Ride, Swim',
    ),
    ClubSport(
      id: 'alpine-skiing',
      name: 'Alpine Skiing',
      icon: Icons.downhill_skiing,
    ),
    ClubSport(
      id: 'backcountry-skiing',
      name: 'Backcountry Skiing',
      icon: Icons.downhill_skiing,
    ),
    ClubSport(id: 'canoeing', name: 'Canoeing', icon: Icons.kayaking),
    ClubSport(id: 'crossfit', name: 'Crossfit', icon: Icons.fitness_center),
    ClubSport(id: 'e-biking', name: 'E-Biking', icon: Icons.electric_bike),
    ClubSport(id: 'elliptical', name: 'Elliptical', icon: Icons.directions_walk),
    ClubSport(
      id: 'football',
      name: 'Football (Soccer)',
      icon: Icons.sports_soccer,
    ),
    ClubSport(id: 'golf', name: 'Golf', icon: Icons.sports_golf),
    ClubSport(
      id: 'handcycling',
      name: 'Handcycling',
      icon: Icons.accessible_forward,
    ),
    ClubSport(id: 'hiking', name: 'Hiking', icon: Icons.hiking),
    ClubSport(id: 'ice-skating', name: 'Ice Skating', icon: Icons.ice_skating),
    ClubSport(
      id: 'inline-skating',
      name: 'Inline Skating',
      icon: Icons.roller_skating,
    ),
    ClubSport(id: 'kayaking', name: 'Kayaking', icon: Icons.kayaking),
    ClubSport(id: 'kitesurfing', name: 'Kitesurfing', icon: Icons.kitesurfing),
    ClubSport(
      id: 'nordic-skiing',
      name: 'Nordic Skiing',
      icon: Icons.nordic_walking,
    ),
    ClubSport(id: 'rock-climbing', name: 'Rock Climbing', icon: Icons.terrain),
    ClubSport(
      id: 'roller-skiing',
      name: 'Roller Skiing',
      icon: Icons.nordic_walking,
    ),
    ClubSport(id: 'rowing', name: 'Rowing', icon: Icons.rowing),
    ClubSport(
      id: 'run-walk-hike',
      name: 'Run/Walk/Hike',
      icon: Icons.directions_run,
      subsports: 'Wheelchair, Run, Trail Run, Walk, Hike, Virtual Run',
    ),
    ClubSport(id: 'sailing', name: 'Sailing', icon: Icons.sailing),
    ClubSport(
      id: 'skateboarding',
      name: 'Skateboarding',
      icon: Icons.skateboarding,
    ),
    ClubSport(
      id: 'ski-snowboard',
      name: 'Ski/Snowboard',
      icon: Icons.ac_unit,
      subsports: 'Alpine Ski, Backcountry Ski, Snowboard',
    ),
    ClubSport(
      id: 'snowboarding',
      name: 'Snowboarding',
      icon: Icons.snowboarding,
    ),
    ClubSport(id: 'snowshoeing', name: 'Snowshoeing', icon: Icons.snowshoeing),
    ClubSport(id: 'stair-stepper', name: 'Stair Stepper', icon: Icons.stairs),
    ClubSport(
      id: 'stand-up-paddling',
      name: 'Stand-up Paddling',
      icon: Icons.kayaking,
    ),
    ClubSport(id: 'surfing', name: 'Surfing', icon: Icons.surfing),
    ClubSport(id: 'swimming', name: 'Swimming', icon: Icons.pool),
    ClubSport(id: 'velomobile', name: 'Velomobile', icon: Icons.pedal_bike),
    ClubSport(
      id: 'virtual-riding',
      name: 'Virtual Riding',
      icon: Icons.pedal_bike,
    ),
    ClubSport(
      id: 'virtual-running',
      name: 'Virtual Running',
      icon: Icons.directions_run,
    ),
    ClubSport(
      id: 'walking',
      name: 'Walking',
      icon: Icons.directions_walk,
      subsports: 'Walk, Wheelchair',
    ),
    ClubSport(
      id: 'weight-training',
      name: 'Weight Training',
      icon: Icons.fitness_center,
    ),
    ClubSport(
      id: 'wheelchair',
      name: 'Wheelchair',
      icon: Icons.accessible_forward,
    ),
    ClubSport(id: 'windsurfing', name: 'Windsurfing', icon: Icons.sailing),
    ClubSport(
      id: 'winter-sports',
      name: 'Winter Sports',
      icon: Icons.ac_unit,
      subsports:
          'Snowshoe, Alpine Ski, Ice Skate, Nordic Ski, Backcountry Ski, Snowboard',
    ),
    ClubSport(id: 'workout', name: 'Workout', icon: Icons.fitness_center),
    ClubSport(id: 'yoga', name: 'Yoga', icon: Icons.self_improvement),
  ];

  static ClubSport byId(String id) {
    return option.firstWhere((s) => s.id == id, orElse: () => allSports);
  }
}

class ClubType {
  final String id;
  final String name;
  final IconData icon;

  const ClubType({required this.id, required this.name, required this.icon});

  static const option = <ClubType>[
    ClubType(id: 'casual', name: 'Casual & social', icon: Icons.emoji_emotions_outlined),
    ClubType(id: 'brand', name: 'Brand or company', icon: Icons.storefront_outlined),
    ClubType(id: 'team', name: 'Team', icon: Icons.groups_outlined),
    ClubType(id: 'workplace', name: 'Workplace group', icon: Icons.business_center_outlined),
    ClubType(id: 'coached', name: 'Coached', icon: Icons.sports_outlined),
    ClubType(id: 'training', name: 'Training group', icon: Icons.fitness_center),
    ClubType(id: 'school', name: 'School or university', icon: Icons.school_outlined),
    ClubType(id: 'charity', name: 'Charity & causes', icon: Icons.volunteer_activism_outlined),
    ClubType(id: 'community', name: 'Local community', icon: Icons.diversity_3_outlined),
  ];
}

class ClubPrivacy {
  final String id;
  final String name;
  final String description;

  const ClubPrivacy({
    required this.id,
    required this.name,
    required this.description,
  });

  static const public = ClubPrivacy(
    id: 'public',
    name: 'Public',
    description: 'Anyone can join and see what the club is up to.',
  );

  static const private = ClubPrivacy(
    id: 'private',
    name: 'Private',
    description: 'People send a request, and an admin approves new members.',
  );

  static const option = <ClubPrivacy>[public, private];
}

class ClubLocation {
  final String name;
  final String detail;
  final double? latitude;
  final double? longitude;

  const ClubLocation({
    required this.name,
    this.detail = '',
    this.latitude,
    this.longitude,
  });
}

class ClubCreationModel {
  final ClubSport sport;
  final List<ClubType> types;
  final String name;
  final String description;
  final String? avatarPath;
  final ClubPrivacy privacy;
  final bool isGlobal;
  final ClubLocation? location;

  const ClubCreationModel({
    this.sport = ClubSport.allSports,
    this.types = const [],
    this.name = '',
    this.description = '',
    this.avatarPath,
    this.privacy = ClubPrivacy.public,
    this.isGlobal = true,
    this.location,
  });

  ClubCreationModel copyWith({
    ClubSport? sport,
    List<ClubType>? types,
    String? name,
    String? description,
    String? avatarPath,
    bool clearAvatar = false,
    ClubPrivacy? privacy,
    bool? isGlobal,
    ClubLocation? location,
  }) {
    return ClubCreationModel(
      sport: sport ?? this.sport,
      types: types ?? this.types,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      privacy: privacy ?? this.privacy,
      isGlobal: isGlobal ?? this.isGlobal,
      location: location ?? this.location,
    );
  }
}
