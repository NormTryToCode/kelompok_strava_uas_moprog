import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

SportType mapClubSportToSportType(ClubSport sport) {
  switch (sport.id.toLowerCase()) {
    case 'cycling':
      return SportType.cycling;
    case 'triathlon':
    case 'swimming':
      return SportType.swimming;
    case 'walking':
    case 'hiking':
      return SportType.walking;
    case 'running':
    default:
      return SportType.running;
  }
}

SearchClub searchClubFromGroupClub(Club club) {
  return SearchClub(
    id: club.id,
    name: club.name,
    sport: mapClubSportToSportType(club.sport),
    memberCount: club.memberCount,
    city: club.locationLabel,
    isVerified: club.memberCount >= 10,
  );
}

final searchClubsProvider = Provider<List<SearchClub>>((ref) {
  final firestoreClubs = ref.watch(clubsProvider).valueOrNull;
  if (firestoreClubs == null || firestoreClubs.isEmpty) {
    return const <SearchClub>[];
  }
  return firestoreClubs.map(searchClubFromGroupClub).toList(growable: false);
});