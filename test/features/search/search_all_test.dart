import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_all.dart';

const _people = [
  Person(
    id: 'p1',
    name: 'Dewi Anggraini',
    location: 'Bandung, West Java',
    tag: 't',
  ),
  Person(
    id: 'p2',
    name: 'Rizky Pratama',
    location: 'Surabaya, East Java',
    tag: 't',
  ),
];

const _clubs = [
  SearchClub(
    id: 'c1',
    name: 'Bandung Trail Society',
    sport: SportType.running,
    memberCount: 100,
    city: 'Bandung',
  ),
  SearchClub(
    id: 'c2',
    name: 'Surabaya Pedal Crew',
    sport: SportType.cycling,
    memberCount: 90,
    city: 'Surabaya',
  ),
];

void main() {
  test('kueri kosong menghasilkan hasil kosong', () {
    final results = searchAll('  ', people: _people, clubs: _clubs);

    expect(results.isEmpty, isTrue);
    expect(results.total, 0);
  });

  test('kueri yang cocok nama orang saja', () {
    final results = searchAll('dewi', people: _people, clubs: _clubs);

    expect(results.people.map((p) => p.id), ['p1']);
    expect(results.clubs, isEmpty);
  });

  test('kueri yang cocok kota mengembalikan orang dan klub', () {
    final results = searchAll('bandung', people: _people, clubs: _clubs);

    expect(results.people.map((p) => p.id), ['p1']);
    expect(results.clubs.map((c) => c.id), ['c1']);
    expect(results.total, 2);
  });

  test('pencarian tidak peka huruf besar dan kecil', () {
    final results = searchAll('SURABAYA', people: _people, clubs: _clubs);

    expect(results.people.map((p) => p.id), ['p2']);
    expect(results.clubs.map((c) => c.id), ['c2']);
  });

  test('kueri tanpa kecocokan menghasilkan hasil kosong', () {
    final results = searchAll('zzz', people: _people, clubs: _clubs);

    expect(results.isEmpty, isTrue);
  });
}