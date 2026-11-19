import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

class ClubFilter {
  final String query;
  final String? city;
  final SportType? sport;

  const ClubFilter({this.query = '', this.city, this.sport});

  bool get isActive =>
      query.trim().isNotEmpty || city != null || sport != null;

  int get activeCount =>
      (query.trim().isNotEmpty ? 1 : 0) +
      (city != null ? 1 : 0) +
      (sport != null ? 1 : 0);

  ClubFilter withQuery(String value) {
    return ClubFilter(query: value, city: city, sport: sport);
  }

  ClubFilter withCity(String? value) {
    return ClubFilter(query: query, city: value, sport: sport);
  }

  ClubFilter withSport(SportType? value) {
    return ClubFilter(query: query, city: city, sport: value);
  }

  List<Club> apply(List<Club> clubs) {
    final needle = query.trim().toLowerCase();
    return clubs.where((club) {
      if (city != null && club.city != city) return false;
      if (sport != null && club.sport != sport) return false;
      if (needle.isEmpty) return true;
      return club.name.toLowerCase().contains(needle) ||
          club.city.toLowerCase().contains(needle);
    }).toList();
  }
}

List<String> citiesOf(List<Club> clubs) {
  final cities = clubs.map((club) => club.city).toSet().toList()..sort();
  return cities;
}