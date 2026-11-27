import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

/// Represents a selectable sport option for activity recording.
class RecordSportItem {
  final String id;
  final String name;
  final String category;
  final IconData icon;

  const RecordSportItem({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
  });
}

/// Groups related sports under a section heading inside the sport filter sheet.
class RecordSportCategory {
  final String title;
  final List<RecordSportItem> sports;

  const RecordSportCategory({
    required this.title,
    required this.sports,
  });
}

/// Catalog of sports for RecordTrackPage, reusing icons from [ClubSport.option].
class RecordSportCatalog {
  RecordSportCatalog._();

  static IconData _clubIcon(String id) => ClubSport.byId(id).icon;

  static final List<RecordSportCategory> categories = [
    RecordSportCategory(
      title: 'Foot Sports',
      sports: [
        RecordSportItem(
          id: 'run',
          name: 'Run',
          category: 'Foot Sports',
          icon: _clubIcon('running'),
        ),
        RecordSportItem(
          id: 'trail-run',
          name: 'Trail Run',
          category: 'Foot Sports',
          icon: _clubIcon('running'),
        ),
        RecordSportItem(
          id: 'walk',
          name: 'Walk',
          category: 'Foot Sports',
          icon: _clubIcon('walking'),
        ),
        RecordSportItem(
          id: 'hike',
          name: 'Hike',
          category: 'Foot Sports',
          icon: _clubIcon('hiking'),
        ),
        RecordSportItem(
          id: 'wheelchair',
          name: 'Wheelchair',
          category: 'Foot Sports',
          icon: _clubIcon('wheelchair'),
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Cycle Sports',
      sports: [
        RecordSportItem(
          id: 'ride',
          name: 'Ride',
          category: 'Cycle Sports',
          icon: _clubIcon('cycling'),
        ),
        RecordSportItem(
          id: 'mountain-bike-ride',
          name: 'Mountain Bike Ride',
          category: 'Cycle Sports',
          icon: _clubIcon('cycling'),
        ),
        RecordSportItem(
          id: 'gravel-ride',
          name: 'Gravel Ride',
          category: 'Cycle Sports',
          icon: _clubIcon('cycling'),
        ),
        RecordSportItem(
          id: 'e-bike-ride',
          name: 'E-Bike Ride',
          category: 'Cycle Sports',
          icon: _clubIcon('e-biking'),
        ),
        RecordSportItem(
          id: 'e-mountain-bike-ride',
          name: 'E-Mountain Bike Ride',
          category: 'Cycle Sports',
          icon: _clubIcon('e-biking'),
        ),
        RecordSportItem(
          id: 'handcycle',
          name: 'Handcycle',
          category: 'Cycle Sports',
          icon: _clubIcon('handcycling'),
        ),
        RecordSportItem(
          id: 'velomobile',
          name: 'Velomobile',
          category: 'Cycle Sports',
          icon: _clubIcon('velomobile'),
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Strength',
      sports: [
        RecordSportItem(
          id: 'weight-training',
          name: 'Weight Training',
          category: 'Strength',
          icon: _clubIcon('weight-training'),
        ),
        RecordSportItem(
          id: 'workout',
          name: 'Workout',
          category: 'Strength',
          icon: _clubIcon('workout'),
        ),
        const RecordSportItem(
          id: 'hybrid-racing',
          name: 'Hybrid Racing',
          category: 'Strength',
          icon: Icons.bolt,
        ),
        const RecordSportItem(
          id: 'hiit',
          name: 'HIIT',
          category: 'Strength',
          icon: Icons.local_fire_department,
        ),
        RecordSportItem(
          id: 'crossfit',
          name: 'Crossfit',
          category: 'Strength',
          icon: _clubIcon('crossfit'),
        ),
        const RecordSportItem(
          id: 'physical-therapy',
          name: 'Physical Therapy',
          category: 'Strength',
          icon: Icons.healing,
        ),
      ],
    ),
    const RecordSportCategory(
      title: 'Racket Sports',
      sports: [
        RecordSportItem(
          id: 'tennis',
          name: 'Tennis',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'padel',
          name: 'Padel',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'pickleball',
          name: 'Pickleball',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'racquetball',
          name: 'Racquetball',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'squash',
          name: 'Squash',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'badminton',
          name: 'Badminton',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
        RecordSportItem(
          id: 'table-tennis',
          name: 'Table Tennis',
          category: 'Racket Sports',
          icon: Icons.sports_tennis,
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Water Sports',
      sports: [
        RecordSportItem(
          id: 'swim',
          name: 'Swim',
          category: 'Water Sports',
          icon: _clubIcon('swimming'),
        ),
        RecordSportItem(
          id: 'surf',
          name: 'Surf',
          category: 'Water Sports',
          icon: _clubIcon('surfing'),
        ),
        RecordSportItem(
          id: 'stand-up-paddling',
          name: 'Stand Up Paddling',
          category: 'Water Sports',
          icon: _clubIcon('stand-up-paddling'),
        ),
        RecordSportItem(
          id: 'windsurf',
          name: 'Windsurf',
          category: 'Water Sports',
          icon: _clubIcon('windsurfing'),
        ),
        RecordSportItem(
          id: 'kayak',
          name: 'Kayak',
          category: 'Water Sports',
          icon: _clubIcon('kayaking'),
        ),
        RecordSportItem(
          id: 'rowing',
          name: 'Rowing',
          category: 'Water Sports',
          icon: _clubIcon('rowing'),
        ),
        RecordSportItem(
          id: 'canoe',
          name: 'Canoe',
          category: 'Water Sports',
          icon: _clubIcon('canoeing'),
        ),
        RecordSportItem(
          id: 'sailing',
          name: 'Sailing',
          category: 'Water Sports',
          icon: _clubIcon('sailing'),
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Winter Sports',
      sports: [
        RecordSportItem(
          id: 'ice-skate',
          name: 'Ice Skate',
          category: 'Winter Sports',
          icon: _clubIcon('ice-skating'),
        ),
        RecordSportItem(
          id: 'alpine-ski',
          name: 'Alpine Ski',
          category: 'Winter Sports',
          icon: _clubIcon('alpine-skiing'),
        ),
        RecordSportItem(
          id: 'nordic-ski',
          name: 'Nordic Ski',
          category: 'Winter Sports',
          icon: _clubIcon('nordic-skiing'),
        ),
        RecordSportItem(
          id: 'skate-nordic-ski',
          name: 'Skate Nordic Ski',
          category: 'Winter Sports',
          icon: _clubIcon('nordic-skiing'),
        ),
        RecordSportItem(
          id: 'classic-nordic-ski',
          name: 'Classic Nordic Ski',
          category: 'Winter Sports',
          icon: _clubIcon('nordic-skiing'),
        ),
        RecordSportItem(
          id: 'snowboard',
          name: 'Snowboard',
          category: 'Winter Sports',
          icon: _clubIcon('snowboarding'),
        ),
        RecordSportItem(
          id: 'snowshoe',
          name: 'Snowshoe',
          category: 'Winter Sports',
          icon: _clubIcon('snowshoeing'),
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Team Sport',
      sports: [
        RecordSportItem(
          id: 'football',
          name: 'Football (Soccer)',
          category: 'Team Sport',
          icon: _clubIcon('football'),
        ),
        const RecordSportItem(
          id: 'basketball',
          name: 'Basketball',
          category: 'Team Sport',
          icon: Icons.sports_basketball,
        ),
        const RecordSportItem(
          id: 'volleyball',
          name: 'Volleyball',
          category: 'Team Sport',
          icon: Icons.sports_volleyball,
        ),
        const RecordSportItem(
          id: 'cricket',
          name: 'Cricket',
          category: 'Team Sport',
          icon: Icons.sports_cricket,
        ),
      ],
    ),
    RecordSportCategory(
      title: 'Other Sports',
      sports: [
        RecordSportItem(
          id: 'inline-skate',
          name: 'Inline Skate',
          category: 'Other Sports',
          icon: _clubIcon('inline-skating'),
        ),
        RecordSportItem(
          id: 'roller-ski',
          name: 'Roller Ski',
          category: 'Other Sports',
          icon: _clubIcon('roller-skiing'),
        ),
        RecordSportItem(
          id: 'rock-climb',
          name: 'Rock Climb',
          category: 'Other Sports',
          icon: _clubIcon('rock-climbing'),
        ),
        RecordSportItem(
          id: 'elliptical',
          name: 'Elliptical',
          category: 'Other Sports',
          icon: _clubIcon('elliptical'),
        ),
        RecordSportItem(
          id: 'stair-stepper',
          name: 'Stair Stepper',
          category: 'Other Sports',
          icon: _clubIcon('stair-stepper'),
        ),
        RecordSportItem(
          id: 'yoga',
          name: 'Yoga',
          category: 'Other Sports',
          icon: _clubIcon('yoga'),
        ),
        const RecordSportItem(
          id: 'dance',
          name: 'Dance',
          category: 'Other Sports',
          icon: Icons.music_note,
        ),
        RecordSportItem(
          id: 'skateboarding',
          name: 'Skateboarding',
          category: 'Other Sports',
          icon: _clubIcon('skateboarding'),
        ),
        RecordSportItem(
          id: 'golf',
          name: 'Golf',
          category: 'Other Sports',
          icon: _clubIcon('golf'),
        ),
        const RecordSportItem(
          id: 'pilates',
          name: 'Pilates',
          category: 'Other Sports',
          icon: Icons.self_improvement,
        ),
      ],
    ),
  ];

  static List<RecordSportItem> get allSports => [
    for (final category in categories) ...category.sports,
  ];

  static const Map<String, String> _aliases = {
    'running': 'Run',
    'walking': 'Walk',
    'cycling': 'Ride',
    'swimming': 'Swim',
    'hiking': 'Hike',
  };

  /// Finds a sport by name (case-insensitive) or returns `Run` as fallback.
  static RecordSportItem byName(String name) {
    final trimmed = name.trim();
    final normalized = _aliases[trimmed.toLowerCase()] ?? trimmed;
    for (final sport in allSports) {
      if (sport.name.toLowerCase() == normalized.toLowerCase()) {
        return sport;
      }
    }
    return categories.first.sports.first;
  }
}
