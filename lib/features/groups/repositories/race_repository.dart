import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';

class RaceRepository {
  static const _collection = 'races';
  final _db = DatabaseService.instance;

  Future<List<Race>> getRaces({String? currentUid}) async {
    final rows = await _db.getAll(_collection);
    final races = rows
        .map((row) => Race.fromJson(row, currentUid: currentUid))
        .toList();
    races.sort((a, b) => a.startDate.compareTo(b.startDate));
    return races;
  }

  Future<void> saveRace(Race race) =>
      _db.save(_collection, race.id, race.toJson());
}