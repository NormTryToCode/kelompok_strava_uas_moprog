import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/friend_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/friend_card.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendRepository _repo = PrefsFriendRepository();
  List<Friend> _friends = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.getFriends();
    if (!mounted) return;
    setState(() {
      _friends = data;
      _loading = false;
    });
  }

  Future<void> _remove(Friend friend) async {
    await _repo.removeFriend(friend.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        title: const Text('Teman'),
        backgroundColor: Styles.background,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _friends.isEmpty
              ? const Center(
                  child: Text('Belum ada teman', style: TextStyle(color: Colors.white70)),
                )
              : ListView.builder(
                  itemCount: _friends.length,
                  itemBuilder: (context, i) => FriendCard(
                    friend: _friends[i],
                    onRemove: () => _remove(_friends[i]),
                  ),
                ),
    );
  }
}