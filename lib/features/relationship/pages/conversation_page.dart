import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/chat_message.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/chat_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/chat_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/message_input.dart';

class ConversationPage extends StatefulWidget {
  final String peerUid;
  final String peerName;

  const ConversationPage({
    super.key,
    required this.peerUid,
    required this.peerName,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _repo = ChatRepository.instance;
  late final String _myUid;
  late final String _chatId;
  late final Stream<List<ChatMessage>> _stream;
  String? _lastMarked;

  @override
  void initState() {
    super.initState();
    _myUid = FirebaseAuth.instance.currentUser!.uid;
    _chatId = ChatRepository.dmChatId(_myUid, widget.peerUid);
    _stream = _repo.watchMessages(_chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        title: Text(widget.peerName),
        backgroundColor: Styles.canvas,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
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
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada pesan',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                final last = messages.last;
                if (last.senderUid != _myUid && _lastMarked != last.id) {
                  _lastMarked = last.id;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _repo.markRead(widget.peerUid),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[messages.length - 1 - i];
                    return ChatBubble(text: m.text, isMine: m.isMine(_myUid));
                  },
                );
              },
            ),
          ),
          MessageInput(onSend: (text) => _repo.sendDirectMessage(widget.peerUid, text)),
        ],
      ),
    );
  }
}