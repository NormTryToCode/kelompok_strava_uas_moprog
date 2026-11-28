import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_invite_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';

final clubInviteRepositoryProvider = Provider<ClubInviteRepository>((ref) {
  return ClubInviteRepository();
});

/// Mengambil daftar user terdaftar (athlete_profiles) agar bisa di-invite antar akun email.
final invitableFriendsProvider = FutureProvider.autoDispose<List<Friend>>((
  ref,
) async {
  final myUid = ref.watch(authStateProvider).valueOrNull?.uid;
  final users = await UserRepository.instance.getAll();
  return [
    for (final u in users)
      if (u.uid != myUid) Friend(id: u.uid, name: u.name, username: u.username),
  ];
});

class ClubInvitesNotifier
    extends FamilyAsyncNotifier<List<ClubInvite>, String> {
  ClubInviteRepository get _repository =>
      ref.read(clubInviteRepositoryProvider);

  @override
  Future<List<ClubInvite>> build(String arg) {
    return _repository.getInvitesByClub(arg);
  }

  Future<int> inviteFriends(
    List<Friend> friends, {
    required String clubName,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    final inviterName =
        (user?.displayName != null && user!.displayName!.trim().isNotEmpty)
        ? user.displayName!.trim()
        : (user?.email?.split('@').first ?? 'Club Admin');
    final now = DateTime.now();

    final drafts = [
      for (final f in friends)
        ClubInvite(
          clubId: arg,
          clubName: clubName,
          friendId: f.id,
          friendName: f.name,
          username: f.username,
          invitedByName: inviterName,
          status: 'pending',
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

class MyPendingInvitesNotifier extends AsyncNotifier<List<ClubInvite>> {
  ClubInviteRepository get _repository =>
      ref.read(clubInviteRepositoryProvider);

  @override
  Future<List<ClubInvite>> build() async {
    final uid = ref.watch(authStateProvider).valueOrNull?.uid;
    if (uid == null || uid.isEmpty) return const [];
    return _repository.getPendingInvitesForUser(uid);
  }

  Future<void> accept(ClubInvite invite) async {
    await ref.read(clubsProvider.notifier).acceptClubInvite(invite.clubId);
    await _repository.removeInvite(invite.clubId, invite.friendId);
    final current = state.valueOrNull ?? const <ClubInvite>[];
    state = AsyncData(
      current
          .where(
            (i) =>
                !(i.clubId == invite.clubId && i.friendId == invite.friendId),
          )
          .toList(),
    );
  }

  Future<void> decline(ClubInvite invite) async {
    await _repository.removeInvite(invite.clubId, invite.friendId);
    final current = state.valueOrNull ?? const <ClubInvite>[];
    state = AsyncData(
      current
          .where(
            (i) =>
                !(i.clubId == invite.clubId && i.friendId == invite.friendId),
          )
          .toList(),
    );
  }
}

final myPendingInvitesProvider =
    AsyncNotifierProvider<MyPendingInvitesNotifier, List<ClubInvite>>(
      MyPendingInvitesNotifier.new,
    );