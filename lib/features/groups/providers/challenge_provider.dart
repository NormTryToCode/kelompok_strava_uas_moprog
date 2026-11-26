import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_challenges.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';

class ChallengesNotifier extends Notifier<List<Challenge>> {
  @override
  List<Challenge> build() => buildDummyChallenges();

  void toggleJoin(String challengeId) {
    state = [
      for (final ch in state)
        if (ch.id == challengeId)
          ch.copyWith(
            isJoined: !ch.isJoined,
            participantCount: ch.isJoined
                ? (ch.participantCount > 0 ? ch.participantCount - 1 : 0)
                : ch.participantCount + 1,
          )
        else
          ch,
    ];
  }

  void addChallenge(Challenge challenge) {
    state = [challenge, ...state];
  }
}

final challengesProvider =
    NotifierProvider<ChallengesNotifier, List<Challenge>>(
      ChallengesNotifier.new,
    );