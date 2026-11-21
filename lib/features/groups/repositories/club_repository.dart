import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/local_json_store.dart';

class ClubRepository {
  final _store = LocalJsonStore<Club>(
    fileName: 'clubs.json',
    rootKey: 'clubs',
    fromJson: Club.fromJson,
    toJson: (c) => c.toJson(),
  );

  Future<List<Club>> getClubs() => _store.readAll();

  Future<void> addClub(Club club) async {
    final clubs = await _store.readAll();
    await _store.writeAll([club, ...clubs]);
  }

  Future<void> updateClub(Club club) async {
    final clubs = await _store.readAll();
    await _store.writeAll([
      for (final item in clubs)
        if (item.id == club.id) club else item,
    ]);
  }

  Future<void> deleteClub(String clubId) async {
    final clubs = await _store.readAll();
    await _store.writeAll(clubs.where((item) => item.id != clubId).toList());
  }
}