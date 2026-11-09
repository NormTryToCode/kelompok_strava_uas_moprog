import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

List<Person> buildDummyPeople() {
  return const [
    Person(
      id: 'p1',
      name: 'Dewi Anggraini',
      location: 'Bandung, West Java',
      tag: 'Strava fan favorite',
    ),
    Person(
      id: 'p2',
      name: 'Rizky Pratama',
      location: 'Surabaya, East Java',
      tag: 'Strava fan favorite',
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