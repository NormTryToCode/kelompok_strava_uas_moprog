import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/conversation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/new_chat_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/friend_card.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  Map<String, UserProfile> _profiles = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final users = await UserRepository.instance.getAll();
    if (!mounted) return;
    setState(() {
      _profiles = {for (final u in users) u.uid: u};
      _loading = false;
    });
  }

  Future<void> _addFriend() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (pageContext) => NewChatPage(
          title: 'Ikuti pengguna',
          onSelect: (user) {
            final notifier = ref.read(followProvider.notifier);
            if (!notifier.isFollowing(user.uid)) notifier.toggle(user.uid);
            Navigator.pop(pageContext);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final followingIds = ref.watch(followProvider);
    final friends = [
      for (final id in followingIds)
        if (_profiles[id] != null)
          Friend(
            id: id,
            name: _profiles[id]!.name,
            username: _profiles[id]!.username,
          ),
    ];

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        title: const Text('Teman'),
        backgroundColor: Styles.canvas,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addFriend,
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewChatPage()),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : friends.isEmpty
              ? const Center(
                  child: Text(
                    'Belum mengikuti siapa pun',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, i) => FriendCard(
                    friend: friends[i],
                    onRemove: () => ref
                        .read(followProvider.notifier)
                        .toggle(friends[i].id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationPage(
                          peerUid: friends[i].id,
                          peerName: friends[i].name,
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}