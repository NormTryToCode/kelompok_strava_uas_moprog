import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/json_club_repository.dart';

abstract class ClubRepository {
  static ClubRepository instance = JsonClubRepository();

  Future<List<Club>> getClubs();

  Future<void> addClub(Club club);
}
