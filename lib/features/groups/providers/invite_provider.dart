import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_invite_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/friend_repository.dart';

final clubInviteRepositoryProvider = Provider<ClubInviteRepository>((ref) {
  return ClubInviteRepository();
});

final invitableFriendsProvider = FutureProvider<List<Friend>>((ref) {
  return PrefsFriendRepository().getFriends();
});

class ClubInvitesNotifier
    extends FamilyAsyncNotifier<List<ClubInvite>, String> {
  ClubInviteRepository get _repository =>
      ref.read(clubInviteRepositoryProvider);

  @override
  Future<List<ClubInvite>> build(String arg) {
    return _repository.getInvitesByClub(arg);
  }

  Future<int> inviteFriends(List<Friend> friends) async {
    final now = DateTime.now();
    final drafts = [
      for (final f in friends)
        ClubInvite(
          clubId: arg,
          friendId: f.id,
          friendName: f.name,
          username: f.username,
          invitedAt: now,
        ),
    ];

    final added = await _repository.addInvites(drafts);
    if (added.isEmpty) return 0;

    final current = state.valueOrNull ?? const <ClubInvite>[];
    state = AsyncData([...current, ...added]);
    return added.length;
  }
}

final clubInvitesProvider =
    AsyncNotifierProvider.family<ClubInvitesNotifier, List<ClubInvite>, String>(
  ClubInvitesNotifier.new,
);