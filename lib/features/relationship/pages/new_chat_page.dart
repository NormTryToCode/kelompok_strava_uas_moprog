import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/pages/conversation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<UserProfile> _all = [];
  String _query = '';
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
      _all = users;
      _loading = false;
    });
  }

  List<UserProfile> get _filtered {
    final me = FirebaseAuth.instance.currentUser?.uid;
    final q = _query.trim().toLowerCase();
    return _all
        .where((u) =>
            u.uid != me &&
            (q.isEmpty ||
                u.name.toLowerCase().contains(q) ||
                u.username.contains(q)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filtered;
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        title: const Text('Pesan baru'),
        backgroundColor: Styles.canvas,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama atau username',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Styles.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada pengguna',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          final u = users[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Styles.accent,
                              child: Text(
                                u.name.isNotEmpty ? u.name[0] : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              u.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '@${u.username}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConversationPage(
                                  peerUid: u.uid,
                                  peerName: u.name,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}