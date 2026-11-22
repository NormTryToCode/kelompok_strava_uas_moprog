import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/local_json_store.dart';

class ClubInviteRepository {
  final _store = LocalJsonStore<ClubInvite>(
    fileName: 'club_invites.json',
    rootKey: 'invites',
    fromJson: ClubInvite.fromJson,
    toJson: (i) => i.toJson(),
  );

  Future<List<ClubInvite>> getInvitesByClub(String clubId) async {
    final all = await _store.readAll();
    return all.where((i) => i.clubId == clubId).toList();
  }

  Future<List<ClubInvite>> addInvites(List<ClubInvite> newInvites) async {
    if (newInvites.isEmpty) return const [];
    final all = await _store.readAll();
    final existingKeys = {
      for (final item in all) '${item.clubId}|${item.friendId}',
    };

    final toAdd = [
      for (final invite in newInvites)
        if (existingKeys.add('${invite.clubId}|${invite.friendId}')) invite,
    ];

    if (toAdd.isEmpty) return const [];
    await _store.writeAll([...all, ...toAdd]);
    return toAdd;
  }
}