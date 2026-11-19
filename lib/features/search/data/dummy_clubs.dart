import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

List<Club> buildDummyClubs() {
  return const [
    Club(
      id: 'club1',
      name: 'Jakarta Sunrise Runners',
      sport: SportType.running,
      memberCount: 46090,
      city: 'Jakarta',
    ),
    Club(
      id: 'club2',
      name: 'Nusantara Cycling Club',
      sport: SportType.cycling,
      memberCount: 22317,
      city: 'Jakarta',
      isVerified: true,
    ),
    Club(
      id: 'club3',
      name: 'Bandung Trail Society',
      sport: SportType.running,
      memberCount: 15290,
      city: 'Bandung',
    ),
    Club(
      id: 'club4',
      name: 'Surabaya Pedal Crew',
      sport: SportType.cycling,
      memberCount: 11786,
      city: 'Surabaya',
    ),
    Club(
      id: 'club5',
      name: 'Bali Open Water Swimmers',
      sport: SportType.swimming,
      memberCount: 8420,
      city: 'Denpasar',
      isVerified: true,
    ),
    Club(
      id: 'club6',
      name: 'Yogyakarta Walking Group',
      sport: SportType.walking,
      memberCount: 6310,
      city: 'Yogyakarta',
    ),
    Club(
      id: 'club7',
      name: 'Medan Road Riders',
      sport: SportType.cycling,
      memberCount: 5875,
      city: 'Medan',
    ),
    Club(
      id: 'club8',
      name: 'Semarang Morning Run',
      sport: SportType.running,
      memberCount: 4932,
      city: 'Semarang',
      isVerified: true,
    ),
    Club(
      id: 'club9',
      name: 'Makassar Harbor Swim',
      sport: SportType.swimming,
      memberCount: 2140,
      city: 'Makassar',
    ),
    Club(
      id: 'club10',
      name: 'Malang Hill Walkers',
      sport: SportType.walking,
      memberCount: 1890,
      city: 'Malang',
    ),
  ];
}