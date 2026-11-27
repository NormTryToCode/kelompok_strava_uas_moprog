import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_races.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_firestore_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/race_repository.dart';

final raceRepositoryProvider = Provider<RaceRepository>((ref) {
  return RaceRepository();
});

class RacesNotifier extends AsyncNotifier<List<Race>> {
  RaceRepository get _repository => ref.read(raceRepositoryProvider);
  String? get _currentUid => ref.read(authStateProvider).valueOrNull?.uid;

  @override
  Future<List<Race>> build() async {
    final user = ref.watch(authStateProvider).valueOrNull;
    final uid = user?.uid;
    if (uid != null && uid.isNotEmpty) {
      await GroupsFirestoreSeeder.ensureSeededForUser(
        uid: uid,
        displayName: user?.displayName ?? user?.email?.split('@').first,
      );
    }
    final remote = await _repository.getRaces(currentUid: uid);
    return remote.isNotEmpty ? remote : buildDummyRaces();
  }

  Future<void> toggleRegistration(String raceId, {String? tierId}) async {
    final uid = _currentUid;
    if (uid == null) return;

    final current = state.valueOrNull ?? const <Race>[];
    Race? updatedRace;
    final nextList = <Race>[];

    for (final race in current) {
      if (race.id == raceId) {
        final nextRegs = Map<String, String>.of(race.registrations);
        if (nextRegs.containsKey(uid)) {
          nextRegs.remove(uid);
          updatedRace = race.copyWith(
            isRegistered: false,
            clearSelectedTier: true,
            registrations: nextRegs,
            registeredCount:
                race.registeredCount > 0 ? race.registeredCount - 1 : 0,
          );
        } else {
          final chosen = tierId ??
              (race.distanceTiers.isNotEmpty
                  ? race.distanceTiers.first.id
                  : 'open');
          nextRegs[uid] = chosen;
          updatedRace = race.copyWith(
            isRegistered: true,
            selectedTierId: chosen,
            registrations: nextRegs,
            registeredCount: race.registeredCount + 1,
          );
        }
        nextList.add(updatedRace);
      } else {
        nextList.add(race);
      }
    }

    if (updatedRace == null) return;
    await _repository.saveRace(updatedRace);
    state = AsyncData(nextList);
  }
}

final racesProvider = AsyncNotifierProvider<RacesNotifier, List<Race>>(
  RacesNotifier.new,
);