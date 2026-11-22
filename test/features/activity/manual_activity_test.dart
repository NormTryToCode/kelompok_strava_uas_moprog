import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';

void main() {
  final activity = ManualActivity(
    id: 'a1',
    title: 'Morning run',
    type: ActivityType.run,
    date: DateTime(2026, 11, 16, 6, 30),
    duration: const Duration(minutes: 30),
    distanceKm: 5,
    notes: 'Easy pace',
  );

  test('pace dan kecepatan rata-rata dihitung dari durasi dan jarak', () {
    expect(activity.pacePerKm, const Duration(minutes: 6));
    expect(activity.averageSpeedKmh, closeTo(10, 0.001));
  });

  test('jarak nol tidak punya pace', () {
    final still = ManualActivity(
      id: 'a2',
      title: 'Yoga',
      type: ActivityType.workout,
      date: DateTime(2026, 11, 16),
      duration: const Duration(minutes: 20),
      distanceKm: 0,
    );

    expect(still.pacePerKm, isNull);
  });

  test('toJson lalu fromJson menghasilkan data yang sama', () {
    final copy = ManualActivity.fromJson(activity.toJson());

    expect(copy.id, 'a1');
    expect(copy.title, 'Morning run');
    expect(copy.type, ActivityType.run);
    expect(copy.date, DateTime(2026, 11, 16, 6, 30));
    expect(copy.duration, const Duration(minutes: 30));
    expect(copy.distanceKm, 5);
    expect(copy.notes, 'Easy pace');
  });

  test('fromJson memakai nilai bawaan untuk data yang hilang', () {
    final copy = ManualActivity.fromJson({'type': 'unknown'});

    expect(copy.type, ActivityType.workout);
    expect(copy.title, '');
    expect(copy.duration, Duration.zero);
    expect(copy.distanceKm, 0);
  });
}