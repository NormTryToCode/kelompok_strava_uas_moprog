import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class EventKind {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  const EventKind({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  static const social = EventKind(
    id: 'social',
    name: 'Social',
    description: 'Relaxed pace, nobody gets left behind',
    icon: Icons.thumb_up_alt_outlined,
  );

  static const workout = EventKind(
    id: 'workout',
    name: 'Workout',
    description: 'Structured training session',
    icon: Icons.monitor_heart_outlined,
  );

  static const competition = EventKind(
    id: 'competition',
    name: 'Competition',
    description: 'Race or timed challenge',
    icon: Icons.sports_score,
  );

  static const option = <EventKind>[social, workout, competition];
}

class EventSurface {
  final String id;
  final String name;

  const EventSurface({required this.id, required this.name});

  static const road = EventSurface(id: 'road', name: 'Road');
  static const trail = EventSurface(id: 'trail', name: 'Trail');
  static const gravel = EventSurface(id: 'gravel', name: 'Gravel');
  static const mixed = EventSurface(id: 'mixed', name: 'Mixed');

  static const option = <EventSurface>[road, trail, gravel, mixed];
}

enum PaceUnit {
  kph('kph'),
  mph('mph');

  final String label;

  const PaceUnit(this.label);
}

enum DistanceUnit {
  km('km'),
  mi('mi');

  final String label;

  const DistanceUnit(this.label);
}

class PaceRange {
  final double min;
  final double max;

  const PaceRange({required this.min, required this.max});
}

class EventRecurrence {
  final bool isMonthly;
  final int interval;

  final bool monthlyByWeekday;

  const EventRecurrence({
    required this.isMonthly,
    this.interval = 1,
    this.monthlyByWeekday = false,
  });

  String summary(DateTime start) {
    if (!isMonthly) {
      final day = weekdayName(start.weekday);
      return interval == 1
          ? 'Every $day'
          : 'Every $interval weeks on $day';
    }

    final rule = monthlyByWeekday
        ? 'the ${ordinal(((start.day - 1) ~/ 7) + 1)} ${weekdayName(start.weekday)}'
        : 'day ${start.day}';
    return interval == 1
        ? 'Monthly on $rule'
        : 'Every $interval months on $rule';
  }

  DateTime next(DateTime current, DateTime first) {
    if (!isMonthly) {
      return DateTime(
        current.year,
        current.month,
        current.day + 7 * interval,
        current.hour,
        current.minute,
      );
    }

    final target = DateTime(current.year, current.month + interval, 1);
    final lastDay = DateTime(target.year, target.month + 1, 0).day;

    int day;
    if (monthlyByWeekday) {
      final nth = ((first.day - 1) ~/ 7) + 1;
      final offset = (first.weekday - target.weekday + 7) % 7;
      day = 1 + offset + 7 * (nth - 1);
      while (day > lastDay) {
        day -= 7;
      }
    } else {
      day = first.day > lastDay ? lastDay : first.day;
    }

    return DateTime(target.year, target.month, day, first.hour, first.minute);
  }

  Map<String, dynamic> toJson() => {
        'isMonthly': isMonthly,
        'interval': interval,
        'monthlyByWeekday': monthlyByWeekday,
      };

  factory EventRecurrence.fromJson(Map<String, dynamic> json) {
    return EventRecurrence(
      isMonthly: json['isMonthly'] as bool? ?? false,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      monthlyByWeekday: json['monthlyByWeekday'] as bool? ?? false,
    );
  }
}

class Event {
  final String id;
  final String clubId;
  final String clubName;
  final String name;
  final ClubSport? sport;
  final DateTime startsAt;
  final EventRecurrence? recurrence;
  final bool isVirtual;
  final ClubLocation? location;
  final String description;
  final bool isDiscoverable;
  final EventKind kind;
  final PaceUnit? paceUnit;
  final List<PaceRange> paceRanges;
  final double? distance;
  final DistanceUnit distanceUnit;
  final EventSurface? surface;
  final bool womenOnly;
  final bool clubMembersOnly;
  final int? capacity;
  final int attendeeCount;
  final DateTime createdAt;

  const Event({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.name,
    required this.sport,
    required this.startsAt,
    required this.recurrence,
    required this.isVirtual,
    required this.location,
    required this.description,
    required this.isDiscoverable,
    required this.kind,
    required this.paceUnit,
    required this.paceRanges,
    required this.distance,
    required this.distanceUnit,
    required this.surface,
    required this.womenOnly,
    required this.clubMembersOnly,
    required this.capacity,
    required this.attendeeCount,
    required this.createdAt,
  });

  String get attendeeLabel =>
      attendeeCount == 1 ? '1 going' : '$attendeeCount going';

  DateTime? nextOccurrence(DateTime now) {
    if (!startsAt.isBefore(now)) return startsAt;

    final rule = recurrence;
    if (rule == null) return null;

    var current = startsAt;
    for (var i = 0; i < 2000; i++) {
      current = rule.next(current, startsAt);
      if (!current.isBefore(now)) return current;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final place = location;
    return {
      'id': id,
      'clubId': clubId,
      'clubName': clubName,
      'name': name,
      'sport': sport?.id,
      'startsAt': startsAt.toIso8601String(),
      'recurrence': recurrence?.toJson(),
      'isVirtual': isVirtual,
      'location': place == null
          ? null
          : {
              'name': place.name,
              'detail': place.detail,
              'latitude': place.latitude,
              'longitude': place.longitude,
            },
      'description': description,
      'isDiscoverable': isDiscoverable,
      'kind': kind.id,
      'paceUnit': paceUnit?.name,
      'paceRanges': paceRanges
          .map((r) => {'min': r.min, 'max': r.max})
          .toList(),
      'distance': distance,
      'distanceUnit': distanceUnit.name,
      'surface': surface?.id,
      'womenOnly': womenOnly,
      'clubMembersOnly': clubMembersOnly,
      'capacity': capacity,
      'attendeeCount': attendeeCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final sportId = json['sport'];
    final place = json['location'];
    final recurrence = json['recurrence'];
    final paceUnitName = json['paceUnit'];
    final surfaceId = json['surface'];
    final ranges = json['paceRanges'];

    return Event(
      id: json['id'] as String? ?? '',
      clubId: json['clubId'] as String? ?? '',
      clubName: json['clubName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sport: sportId is String
          ? ClubSport.option.firstWhere(
              (s) => s.id == sportId,
              orElse: () => ClubSport.allSports,
            )
          : null,
      startsAt: DateTime.tryParse(json['startsAt'] as String? ?? '') ??
          DateTime.now(),
      recurrence: recurrence is Map<String, dynamic>
          ? EventRecurrence.fromJson(recurrence)
          : null,
      isVirtual: json['isVirtual'] as bool? ?? false,
      location: place is Map
          ? ClubLocation(
              name: place['name'] as String? ?? '',
              detail: place['detail'] as String? ?? '',
              latitude: (place['latitude'] as num?)?.toDouble(),
              longitude: (place['longitude'] as num?)?.toDouble(),
            )
          : null,
      description: json['description'] as String? ?? '',
      isDiscoverable: json['isDiscoverable'] as bool? ?? true,
      kind: EventKind.option.firstWhere(
        (k) => k.id == json['kind'],
        orElse: () => EventKind.social,
      ),
      paceUnit: paceUnitName is String
          ? PaceUnit.values.firstWhere(
              (u) => u.name == paceUnitName,
              orElse: () => PaceUnit.kph,
            )
          : null,
      paceRanges: ranges is List
          ? ranges
              .whereType<Map>()
              .map((r) => PaceRange(
                    min: (r['min'] as num?)?.toDouble() ?? 0,
                    max: (r['max'] as num?)?.toDouble() ?? 0,
                  ))
              .toList()
          : const [],
      distance: (json['distance'] as num?)?.toDouble(),
      distanceUnit: DistanceUnit.values.firstWhere(
        (u) => u.name == json['distanceUnit'],
        orElse: () => DistanceUnit.km,
      ),
      surface: surfaceId is String
          ? EventSurface.option.firstWhere(
              (s) => s.id == surfaceId,
              orElse: () => EventSurface.mixed,
            )
          : null,
      womenOnly: json['womenOnly'] as bool? ?? false,
      clubMembersOnly: json['clubMembersOnly'] as bool? ?? true,
      capacity: (json['capacity'] as num?)?.toInt(),
      attendeeCount: (json['attendeeCount'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
