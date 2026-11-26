import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  return ClubRepository();
});

class ClubsNotifier extends AsyncNotifier<List<Club>> {
  ClubRepository get _repository => ref.read(clubRepositoryProvider);

  @override
  Future<List<Club>> build() => _repository.getClubs();

  Future<void> addClub(Club club) async {
    await _repository.addClub(club);
    final current = state.valueOrNull ?? const <Club>[];
    final filtered = current.where((c) => c.id != club.id).toList();
    state = AsyncData([club, ...filtered]);
  }

  Future<void> updateClub(Club updated) async {
    await _repository.updateClub(updated);
    final current = state.valueOrNull ?? const <Club>[];
    state = AsyncData([
      for (final club in current)
        if (club.id == updated.id) updated else club,
    ]);
  }

  Future<void> joinClub(String clubId) async {
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || match.first.isJoined) return;

    final updated = match.first.copyWith(
      isJoined: true,
      memberCount: match.first.memberCount + 1,
    );
    await updateClub(updated);
  }

  Future<void> leaveClub(String clubId) async {
    final current = state.valueOrNull ?? const <Club>[];
    final match = current.where((c) => c.id == clubId);
    if (match.isEmpty || match.first.isOwner) return;

    final club = match.first;
    final updated = club.copyWith(
      isJoined: false,
      isAdmin: false,
      memberCount: club.memberCount > 0 ? club.memberCount - 1 : 0,
    );
    await updateClub(updated);
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
        memberCount: nextMembers.length + (club.isJoined ? 1 : 0),
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