import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club_filter.dart';

const _clubs = [
  Club(
    id: 'a',
    name: 'Jakarta Sunrise Runners',
    sport: SportType.running,
    memberCount: 100,
    city: 'Jakarta',
  ),
  Club(
    id: 'b',
    name: 'Nusantara Cycling Club',
    sport: SportType.cycling,
    memberCount: 90,
    city: 'Jakarta',
  ),
  Club(
    id: 'c',
    name: 'Bandung Trail Society',
    sport: SportType.running,
    memberCount: 80,
    city: 'Bandung',
  ),
  Club(
    id: 'd',
    name: 'Bali Open Water Swimmers',
    sport: SportType.swimming,
    memberCount: 70,
    city: 'Denpasar',
  ),
];

List<String> _ids(List<Club> clubs) => clubs.map((c) => c.id).toList();

void main() {
  test('filter kosong mengembalikan semua klub dan tidak aktif', () {
    const filter = ClubFilter();

    expect(_ids(filter.apply(_clubs)), ['a', 'b', 'c', 'd']);
    expect(filter.isActive, isFalse);
    expect(filter.activeCount, 0);
  });

  test('query tidak peka huruf besar dan kecil', () {
    const filter = ClubFilter(query: 'CYCLING');

    expect(_ids(filter.apply(_clubs)), ['b']);
  });

  test('query juga mencocokkan nama kota', () {
    const filter = ClubFilter(query: 'denpasar');

    expect(_ids(filter.apply(_clubs)), ['d']);
  });

  test('query berisi spasi saja dianggap kosong', () {
    const filter = ClubFilter(query: '   ');

    expect(filter.isActive, isFalse);
    expect(_ids(filter.apply(_clubs)), ['a', 'b', 'c', 'd']);
  });

  test('filter kota', () {
    const filter = ClubFilter(city: 'Jakarta');

    expect(_ids(filter.apply(_clubs)), ['a', 'b']);
  });

  test('filter jenis olahraga', () {
    const filter = ClubFilter(sport: SportType.running);

    expect(_ids(filter.apply(_clubs)), ['a', 'c']);
  });

  test('kota dan olahraga digabung dengan AND', () {
    const filter = ClubFilter(city: 'Jakarta', sport: SportType.running);

    expect(_ids(filter.apply(_clubs)), ['a']);
  });

  test('tidak ada yang cocok menghasilkan daftar kosong', () {
    const filter = ClubFilter(query: 'zzz');

    expect(filter.apply(_clubs), isEmpty);
  });

  test('activeCount menghitung query, kota, dan olahraga', () {
    const filter = ClubFilter(
      query: ' run ',
      city: 'Jakarta',
      sport: SportType.running,
    );

    expect(filter.activeCount, 3);
  });

  test('withCity null menghapus filter kota', () {
    const filter = ClubFilter(city: 'Jakarta');

    expect(filter.withCity(null).city, isNull);
  });

  test('citiesOf mengembalikan kota unik dan terurut', () {
    expect(citiesOf(_clubs), ['Bandung', 'Denpasar', 'Jakarta']);
  });
}