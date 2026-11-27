import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/conversation.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/conversation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/friend_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/new_chat_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/chat_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/conversation_tile.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late final String _myUid;
  late final Stream<List<Conversation>> _stream;
  Map<String, UserProfile> _profiles = {};

  @override
  void initState() {
    super.initState();
    _myUid = FirebaseAuth.instance.currentUser!.uid;
    _stream = ChatRepository.instance.watchConversations();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final users = await UserRepository.instance.getAll();
    if (!mounted) return;
    setState(() => _profiles = {for (final u in users) u.uid: u});
  }

  String _timeLabel(DateTime t) {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final sameDay =
        t.year == now.year && t.month == now.month && t.day == now.day;
    return sameDay ? '${two(t.hour)}:${two(t.minute)}' : '${two(t.day)}/${two(t.month)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: Styles.canvas,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FriendsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewChatPage()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat pesan',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final conversations = snapshot.data!;
          if (conversations.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada percakapan.\nTekan ikon pensil untuk memulai.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, i) {
              final c = conversations[i];
              final peerUid = c.peerUid(_myUid);
              final name = _profiles[peerUid]?.name ?? 'Pengguna';
              final prefix = c.lastSenderUid == _myUid ? 'Kamu: ' : '';
              return ConversationTile(
                unread: c.isUnread(_myUid),
                name: name,
                preview: '$prefix${c.lastMessage}',
                time: _timeLabel(c.updatedAt),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ConversationPage(peerUid: peerUid, peerName: name),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}