import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_firestore_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return ClubRepository();
});

class ClubsNotifier extends AsyncNotifier<List<Club>> {
  ClubRepository get _repository => ref.read(clubRepositoryProvider);
  String? get _currentUid => ref.read(authStateProvider).valueOrNull?.uid;

  @override
  Future<List<Club>> build() async {
    final user = ref.watch(authStateProvider).valueOrNull;
    final uid = user?.uid;
    if (uid != null && uid.isNotEmpty) {
      await GroupsFirestoreSeeder.ensureSeededForUser(
        uid: uid,
        displayName: user?.displayName ?? user?.email?.split('@').first,
      );
    }
    return _repository.getClubs(currentUid: uid);
  }

  Future<void> addClub(Club club) async {
    final uid = _currentUid;
    final withOwner = (uid != null && club.ownerId == null)
        ? club.copyWith(
            ownerId: uid,
            memberIds: club.memberIds.contains(uid)
                ? club.memberIds
                : [...club.memberIds, uid],
            memberCount: club.memberIds.contains(uid)
                ? club.memberIds.length
                : club.memberIds.length + 1,
            isOwner: true,
            isAdmin: true,
            isJoined: true,
          )
        : club;

    await _repository.addClub(withOwner);
    final current = state.valueOrNull ?? const <Club>[];
    final filtered = current.where((c) => c.id != withOwner.id).toList();
    state = AsyncData([withOwner, ...filtered]);
  }

  Future<void> updateClub(Club updated) async {
    await _repository.updateClub(updated);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData([
      for (final club in current)
        if (club.id == updated.id) updated else club,
    ]);
  }

  /// Mengembalikan `true` jika langsung join (Public), `false` jika mengirim/membatalkan request (Private).
  Future<bool> joinClub(String clubId) async {
    final uid = _currentUid;
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || match.first.isJoined || uid == null) return false;

    final club = match.first;

    if (club.isPrivate) {
      final alreadyPending = club.pendingRequestIds.contains(uid);
      final nextPending = alreadyPending
          ? club.pendingRequestIds.where((id) => id != uid).toList()
          : [...club.pendingRequestIds, uid];
      await updateClub(
        club.copyWith(
          pendingRequestIds: nextPending,
          hasPendingRequest: !alreadyPending,
        ),
      );
      return false;
    }

    final nextMembers = club.memberIds.contains(uid)
        ? club.memberIds
        : [...club.memberIds, uid];

    await updateClub(
      club.copyWith(
        isJoined: true,
        hasPendingRequest: false,
        memberIds: nextMembers,
        memberCount: nextMembers.length,
      ),
    );
    return true;
  }

  /// Langsung bergabung ke klub (termasuk Private) karena sudah di-invite oleh Owner/Admin.
  Future<void> acceptClubInvite(String clubId) async {
    final uid = _currentUid;
    if (uid == null) return;

    final current = state.valueOrNull ?? await _repository.getClubs(currentUid: uid);
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty) return;

    final club = match.first;
    final nextMembers = club.memberIds.contains(uid)
        ? club.memberIds
        : [...club.memberIds, uid];
    final nextPending = club.pendingRequestIds.where((id) => id != uid).toList();

    await updateClub(
      club.copyWith(
        isJoined: true,
        hasPendingRequest: false,
        memberIds: nextMembers,
        pendingRequestIds: nextPending,
        memberCount: nextMembers.length,
      ),
    );
  }

  Future<void> leaveClub(String clubId) async {
    final uid = _currentUid;
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || match.first.isOwner || uid == null) return;

    final club = match.first;
    final nextMembers = club.memberIds.where((id) => id != uid).toList();
    final nextAdmins = club.adminIds.where((id) => id != uid).toList();

    await updateClub(
      club.copyWith(
        isJoined: false,
        isAdmin: false,
        memberIds: nextMembers,
        adminIds: nextAdmins,
        memberCount: nextMembers.length,
      ),
    );
  }

  Future<void> toggleMemberAdmin(String clubId, String memberId) async {
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || !match.first.isOwner) return;

    final club = match.first;
    final nextAdmins = List<String>.of(club.adminIds);
    if (!nextAdmins.remove(memberId)) {
      nextAdmins.add(memberId);
    }
    await updateClub(club.copyWith(adminIds: nextAdmins));
  }

  Future<void> deleteClub(String clubId) async {
    await _repository.deleteClub(clubId);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData(current.where((c) => c.id != clubId).toList());
  }

  Future<void> approveJoinRequest(String clubId, String userId) async {
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || !match.first.canManage) return;

    final club = match.first;
    if (!club.pendingRequestIds.contains(userId)) return;

    final nextPending = club.pendingRequestIds
        .where((id) => id != userId)
        .toList();
    final nextMembers = club.memberIds.contains(userId)
        ? club.memberIds
        : [...club.memberIds, userId];

    await updateClub(
      club.copyWith(
        pendingRequestIds: nextPending,
        memberIds: nextMembers,
        memberCount: nextMembers.length,
      ),
    );
  }

  Future<void> declineJoinRequest(String clubId, String userId) async {
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || !match.first.canManage) return;

    final club = match.first;
    final nextPending = club.pendingRequestIds
        .where((id) => id != userId)
        .toList();

    await updateClub(club.copyWith(pendingRequestIds: nextPending));
  }
}

final clubsProvider = AsyncNotifierProvider<ClubsNotifier, List<Club>>(
  ClubsNotifier.new,
);