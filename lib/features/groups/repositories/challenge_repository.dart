import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';

class ChallengeRepository {
  static const _collection = 'challenges';
  final _db = DatabaseService.instance;

  Future<List<Challenge>> getChallenges({String? currentUid}) async {
    final rows = await _db.getAll(_collection);
    final challenges = rows
        .map((row) => Challenge.fromJson(row, currentUid: currentUid))
        .toList();
    challenges.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return challenges;
  }

  Future<void> saveChallenge(Challenge challenge) =>
      _db.save(_collection, challenge.id, challenge.toJson());
}