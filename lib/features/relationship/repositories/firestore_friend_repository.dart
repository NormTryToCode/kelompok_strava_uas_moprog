import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/friend_repository.dart';

class FirestoreFriendRepository implements FriendRepository {
  final _db = DatabaseService.instance;

  @override
  Future<List<Friend>> getFriends() async =>
      (await _db.getAll('friends')).map(Friend.fromJson).toList();

  @override
  Future<void> addFriend(Friend friend) =>
      _db.save('friends', friend.id, friend.toJson());

  @override
  Future<void> removeFriend(String id) => _db.remove('friends', id);
}