import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/utils/activity_format.dart';

void main() {
  test('formatDuration tanpa dan dengan jam', () {
    expect(formatDuration(const Duration(minutes: 45, seconds: 5)), '45:05');
    expect(
      formatDuration(const Duration(hours: 1, minutes: 5, seconds: 30)),
      '1:05:30',
    );
  });

  test('formatDistance membuang nol di belakang', () {
    expect(formatDistance(5), '5 km');
    expect(formatDistance(10), '10 km');
    expect(formatDistance(5.2), '5.2 km');
    expect(formatDistance(5.256), '5.26 km');
  });

  test('formatPace dan formatDate', () {
    expect(formatPace(const Duration(minutes: 5, seconds: 30)), '5:30 /km');
    expect(formatDate(DateTime(2026, 11, 16)), '16 Nov 2026');
  });

  test('parseDuration menerima menit, h:mm, dan h:mm:ss', () {
    expect(parseDuration('45'), const Duration(minutes: 45));
    expect(parseDuration('1:30'), const Duration(hours: 1, minutes: 30));
    expect(
      parseDuration('1:05:30'),
      const Duration(hours: 1, minutes: 5, seconds: 30),
    );
  });

  test('parseDuration menolak input yang tidak valid', () {
    for (final input in ['', '0', 'abc', '-5', '1:75', '1:2:99', '1:2:3:4']) {
      expect(parseDuration(input), isNull, reason: input);
    }
  });

  test('parseDistance menerima koma dan titik', () {
    expect(parseDistance('5,2'), 5.2);
    expect(parseDistance(' 10 '), 10);
  });

  test('parseDistance menolak input yang tidak valid', () {
    for (final input in ['', '0', 'abc', '-1', '1001', 'NaN']) {
      expect(parseDistance(input), isNull, reason: input);
    }
  });
}