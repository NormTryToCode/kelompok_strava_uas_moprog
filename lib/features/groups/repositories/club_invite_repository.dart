import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';

class ClubInviteRepository {
  static const _collection = 'club_invites';
  final _db = DatabaseService.instance;

  String _docId(String clubId, String friendId) => '${clubId}_$friendId';

  Future<List<ClubInvite>> getInvitesByClub(String clubId) async {
    final rows = await _db.getWhere(_collection, 'clubId', clubId);
    return rows.map(ClubInvite.fromJson).toList();
  }

  Future<List<ClubInvite>> addInvites(List<ClubInvite> newInvites) async {
    if (newInvites.isEmpty) return const [];

    final clubId = newInvites.first.clubId;
    final existing = await getInvitesByClub(clubId);
    final existingIds = {
      for (final item in existing) _docId(item.clubId, item.friendId),
    };

    final toAdd = <ClubInvite>[];
    for (final invite in newInvites) {
      final key = _docId(invite.clubId, invite.friendId);
      if (existingIds.add(key)) {
        await _db.save(_collection, key, invite.toJson());
        toAdd.add(invite);
      }
    }
    return toAdd;
  }
}