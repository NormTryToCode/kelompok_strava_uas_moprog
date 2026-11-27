import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_challenges.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_firestore_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/challenge_repository.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository();
});

class ChallengesNotifier extends AsyncNotifier<List<Challenge>> {
  ChallengeRepository get _repository => ref.read(challengeRepositoryProvider);
  String? get _currentUid => ref.read(authStateProvider).valueOrNull?.uid;

  @override
  Future<List<Challenge>> build() async {
    final user = ref.watch(authStateProvider).valueOrNull;
    final uid = user?.uid;
    if (uid != null && uid.isNotEmpty) {
      await GroupsFirestoreSeeder.ensureSeededForUser(
        uid: uid,
        displayName: user?.displayName ?? user?.email?.split('@').first,
      );
    }
    final remote = await _repository.getChallenges(currentUid: uid);
    return remote.isNotEmpty ? remote : buildDummyChallenges();
  }

  Future<void> toggleJoin(String challengeId) async {
    final uid = _currentUid;
    if (uid == null) return;

    final current = state.valueOrNull ?? const <Challenge>[];
    Challenge? updated;
    final nextList = <Challenge>[];

    for (final ch in current) {
      if (ch.id == challengeId) {
        final joining = !ch.participantIds.contains(uid);
        final nextIds = joining
            ? [...ch.participantIds, uid]
            : ch.participantIds.where((id) => id != uid).toList();
        updated = ch.copyWith(
          isJoined: joining,
          participantIds: nextIds,
          participantCount: joining
              ? ch.participantCount + 1
              : (ch.participantCount > 0 ? ch.participantCount - 1 : 0),
        );
        nextList.add(updated);
      } else {
        nextList.add(ch);
      }
    }

    if (updated == null) return;
    await _repository.saveChallenge(updated);
    state = AsyncData(nextList);
  }

  Future<void> addChallenge(Challenge challenge) async {
    final uid = _currentUid;
    final nextIds = (uid != null && !challenge.participantIds.contains(uid))
        ? [...challenge.participantIds, uid]
        : challenge.participantIds;
    final prepared = challenge.copyWith(
      participantIds: nextIds,
      isJoined: uid != null && nextIds.contains(uid),
    );

    await _repository.saveChallenge(prepared);
    final current = state.valueOrNull ?? const <Challenge>[];
    state = AsyncData([prepared, ...current]);
  }
}

final challengesProvider =
    AsyncNotifierProvider<ChallengesNotifier, List<Challenge>>(
      ChallengesNotifier.new,
    );