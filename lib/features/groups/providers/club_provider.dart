import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return ClubRepository.instance;
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