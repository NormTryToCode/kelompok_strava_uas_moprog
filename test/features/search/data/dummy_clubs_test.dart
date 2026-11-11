import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

void main() {
  test('id klub unik', () {
    final clubs = buildDummyClubs();

    expect(clubs.map((c) => c.id).toSet().length, clubs.length);
  });

  test('semua jenis olahraga terwakili', () {
    final sports = buildDummyClubs().map((c) => c.sport).toSet();

    expect(sports, SportType.values.toSet());
  });

  test('jumlah anggota selalu positif', () {
    expect(buildDummyClubs().every((c) => c.memberCount > 0), isTrue);
  });
}