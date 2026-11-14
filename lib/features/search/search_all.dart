import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club_filter.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

class SearchResults {
  final List<Person> people;
  final List<Club> clubs;

  const SearchResults({required this.people, required this.clubs});

  bool get isEmpty => people.isEmpty && clubs.isEmpty;

  int get total => people.length + clubs.length;
}

SearchResults searchAll(
  String query, {
  required List<Person> people,
  required List<Club> clubs,
}) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return const SearchResults(people: [], clubs: []);

  return SearchResults(
    people: people
        .where(
          (p) =>
              p.name.toLowerCase().contains(needle) ||
              p.location.toLowerCase().contains(needle),
        )
        .toList(),
    clubs: ClubFilter(query: query).apply(clubs),
  );
}