import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

List<SearchClub> buildDummyClubs() {
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
    SearchClub(
      id: 'club7',
      name: 'Medan Road Riders',
      sport: SportType.cycling,
      memberCount: 5875,
      city: 'Medan',
    ),
    SearchClub(
      id: 'club8',
      name: 'Semarang Morning Run',
      sport: SportType.running,
      memberCount: 4932,
      city: 'Semarang',
      isVerified: true,
    ),
    SearchClub(
      id: 'club9',
      name: 'Makassar Harbor Swim',
      sport: SportType.swimming,
      memberCount: 2140,
      city: 'Makassar',
    ),
    SearchClub(
      id: 'club10',
      name: 'Malang Hill Walkers',
      sport: SportType.walking,
      memberCount: 1890,
      city: 'Malang',
    ),
  ];
}