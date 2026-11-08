import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';

abstract class FriendRepository {
  Future<List<Friend>> getFriends();
  Future<void> addFriend(Friend friend);
  Future<void> removeFriend(String id);
}

class PrefsFriendRepository implements FriendRepository {
  static const _key = 'friends';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const _seed = [
    Friend(id: '1', name: 'Willson', username: 'willson'),
    Friend(id: '2', name: 'Louise', username: 'louise'),
    Friend(id: '3', name: 'Michael', username: 'michael'),
  ];

  @override
  Future<List<Friend>> getFriends() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) {
      await _save(_seed);
      return List.of(_seed);
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Friend.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addFriend(Friend friend) async {
    final friends = await getFriends();
    await _save([...friends, friend]);
  }

  @override
  Future<void> removeFriend(String id) async {
    final friends = await getFriends();
    await _save(friends.where((f) => f.id != id).toList());
  }

  Future<void> _save(List<Friend> friends) =>
      _prefs.setString(_key, jsonEncode(friends.map((f) => f.toJson()).toList()));
}