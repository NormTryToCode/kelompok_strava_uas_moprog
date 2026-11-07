import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';

void main() {
  final now = DateTime(2026, 11, 6, 12);

  test('kurang dari semenit', () {
    expect(
      now.subtract(const Duration(seconds: 20)).timeAgo(now: now),
      'Just now',
    );
  });

  test('satuan tunggal tanpa s', () {
    expect(
      now.subtract(const Duration(hours: 1)).timeAgo(now: now),
      '1 hour ago',
    );
  });

  test('hari jamak', () {
    expect(
      now.subtract(const Duration(days: 11)).timeAgo(now: now),
      '11 days ago',
    );
  });
}