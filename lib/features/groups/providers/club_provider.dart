import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return ClubRepository();
});

class ClubsNotifier extends AsyncNotifier<List<Club>> {
  ClubRepository get _repository => ref.read(clubRepositoryProvider);

  @override
  Future<List<Club>> build() async {
    return _repository.getClubs();
  }

  Future<void> addClub(Club club) async {
    await _repository.addClub(club);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData([club, ...current]);
  }

  Future<void> updateClub(Club updated) async {
    await _repository.updateClub(updated);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData([
      for (final club in current)
        if (club.id == updated.id) updated else club,
    ]);
  }

  Future<void> deleteClub(String clubId) async {
    await _repository.deleteClub(clubId);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData(current.where((c) => c.id != clubId).toList());
  }
}

final clubsProvider = AsyncNotifierProvider<ClubsNotifier, List<Club>>(
  ClubsNotifier.new,
);

class JoinedPopularClubsNotifier extends AsyncNotifier<Set<String>> {
  static const _collection = 'joined_clubs';
  final _db = DatabaseService.instance;

  @override
  Future<Set<String>> build() async {
    final rows = await _db.getAll(_collection);
    return {
      for (final row in rows)
        if (row['id'] is String) row['id'] as String,
    };
  }

  Future<void> toggle(String clubId) async {
    final current = Set<String>.of(state.valueOrNull ?? const <String>{});
    final joining = current.add(clubId);

    if (joining) {
      await _db.save(_collection, clubId, {
        'clubId': clubId,
        'joinedAt': DateTime.now().toIso8601String(),
      });
    } else {
      current.remove(clubId);
      await _db.remove(_collection, clubId);
    }
    state = AsyncData(current);
  }
}

final joinedPopularClubsProvider =
    AsyncNotifierProvider<JoinedPopularClubsNotifier, Set<String>>(
  JoinedPopularClubsNotifier.new,
);