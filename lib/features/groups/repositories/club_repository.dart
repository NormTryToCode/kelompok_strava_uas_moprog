import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class ClubRepository {
  final _db = DatabaseService.instance;

  Future<List<Club>> getClubs({String? currentUid}) async {
    final clubs = (await _db.getAll('clubs'))
        .map((row) => Club.fromJson(row, currentUid: currentUid))
        .toList();
    clubs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return clubs;
  }

  Future<void> addClub(Club club) => _db.save('clubs', club.id, club.toJson());

  Future<void> updateClub(Club club) =>
      _db.save('clubs', club.id, club.toJson());

  Future<void> deleteClub(String clubId) => _db.remove('clubs', clubId);
}