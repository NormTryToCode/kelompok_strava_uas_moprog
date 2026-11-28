import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

List<SearchClub> buildSeedClubs() {
  return const [
    SearchClub(
      id: 'club1',
      name: 'Jakarta Sunrise Runners',
      sport: SportType.running,
      memberCount: 46090,
      city: 'Jakarta',
    ),
    SearchClub(
      id: 'club2',
      name: 'Nusantara Cycling Club',
      sport: SportType.cycling,
      memberCount: 22317,
      city: 'Jakarta',
      isVerified: true,
    ),
    SearchClub(
      id: 'club3',
      name: 'Bandung Trail Society',
      sport: SportType.running,
      memberCount: 15290,
      city: 'Bandung',
    ),
    SearchClub(
      id: 'club4',
      name: 'Surabaya Pedal Crew',
      sport: SportType.cycling,
      memberCount: 11786,
      city: 'Surabaya',
    ),
    SearchClub(
      id: 'club5',
      name: 'Bali Open Water Swimmers',
      sport: SportType.swimming,
      memberCount: 8420,
      city: 'Denpasar',
      isVerified: true,
    ),
    SearchClub(
      id: 'club6',
      name: 'Yogyakarta Walking Group',
      sport: SportType.walking,
      memberCount: 6310,
      city: 'Yogyakarta',
    ),
  ];
}

List<Person> buildSeedPeople() {
  return const [
    Person(
      id: 'p1',
      name: 'Dewi Anggraini',
      location: 'Bandung, West Java',
      tag: 'Stride athlete',
    ),
    Person(
      id: 'p2',
      name: 'Rizky Pratama',
      location: 'Surabaya, East Java',
      tag: 'Stride athlete',
    ),
    Person(
      id: 'p3',
      name: 'Maya Lestari',
      location: 'Yogyakarta',
      tag: 'Local Legend near you',
    ),
    Person(
      id: 'p4',
      name: 'Bagas Wicaksono',
      location: 'Bekasi',
      tag: 'Local Legend near you',
    ),
    Person(
      id: 'p5',
      name: 'Nadia Putri',
      location: 'Medan, North Sumatra',
      tag: 'Local Legend near you',
    ),
  ];
}