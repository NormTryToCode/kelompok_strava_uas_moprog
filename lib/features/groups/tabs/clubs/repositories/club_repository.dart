import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/repositories/json_club_repository.dart';

abstract class ClubRepository {
  static ClubRepository instance = JsonClubRepository();

  Future<List<Club>> getClubs();

  Future<void> addClub(Club club);
}
