import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/weekly_activity_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/home/models/weekly_activity_model.dart';

class _SeedDayPreset {
  final double distanceKm;
  final int calories;
  final int steps;

  const _SeedDayPreset({
    required this.distanceKm,
    required this.calories,
    required this.steps,
  });
}

class WeeklyActivitySeeder {
  WeeklyActivitySeeder._();

  static const List<_SeedDayPreset> _presets = [
    _SeedDayPreset(distanceKm: 3.2, calories: 245, steps: 4600),
    _SeedDayPreset(distanceKm: 5.4, calories: 410, steps: 7800),
    _SeedDayPreset(distanceKm: 4.1, calories: 315, steps: 6200),
    _SeedDayPreset(distanceKm: 6.5, calories: 495, steps: 9400),
    _SeedDayPreset(distanceKm: 5.0, calories: 380, steps: 7500),
    _SeedDayPreset(distanceKm: 8.2, calories: 630, steps: 11800),
    _SeedDayPreset(distanceKm: 4.6, calories: 355, steps: 6900),
  ];

  static WeeklyActivityData buildDummyWeek({
    required String userId,
    DateTime? referenceDate,
  }) {
    final monday = WeeklyActivityData.mondayOfWeek(
      referenceDate ?? DateTime.now(),
    );
    final weekStart = WeeklyActivityData.formatDateIso(monday);
    final docId = '${userId}_$weekStart';

    final days = List<DailyActivityEntry>.generate(_presets.length, (index) {
      final preset = _presets[index];
      final dayDate = DateTime(monday.year, monday.month, monday.day + index);
      return DailyActivityEntry(
        dayIndex: index,
        dayLabel: WeeklyActivityData.weekdayLabels[index],
        dateIso: WeeklyActivityData.formatDateIso(dayDate),
        distanceKm: preset.distanceKm,
        calories: preset.calories,
        steps: preset.steps,
      );
    });

    return WeeklyActivityData(
      id: docId,
      userId: userId,
      weekStartDate: weekStart,
      days: List.unmodifiable(days),
      isSeeded: true,
      updatedAt: DateTime.now(),
    );
  }

  static Future<WeeklyActivityData> seedCurrentWeekIfMissing({
    required String userId,
    required WeeklyActivityStore repository,
    DateTime? referenceDate,
  }) async {
    final refDate = referenceDate ?? DateTime.now();
    final existing = await repository.fetchWeek(
      userId: userId,
      referenceDate: refDate,
    );
    if (existing != null) return existing;

    final seeded = buildDummyWeek(userId: userId, referenceDate: refDate);
    debugPrint('[WeeklyActivitySeeder] Seeding weekly_activities/${seeded.id}...');
    await repository.saveWeek(seeded);
    return seeded;
  }

  static Future<WeeklyActivityData> reseedWeek({
    required String userId,
    required WeeklyActivityStore repository,
    DateTime? referenceDate,
  }) async {
    final seeded = buildDummyWeek(
      userId: userId,
      referenceDate: referenceDate ?? DateTime.now(),
    );
    await repository.saveWeek(seeded);
    return seeded;
  }
}
