import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/message.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/message_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/chat_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/widgets/message_input.dart';

class ChatPage extends StatefulWidget {
  final Friend friend;

  const ChatPage({super.key, required this.friend});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessageRepository _repo = MessageRepository.instance;
  List<Message> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.getMessages(widget.friend.id);
    if (!mounted) return;
    setState(() {
      _messages = data;
      _loading = false;
    });
  }

  Future<void> _send(String text) async {
    await _repo.addMessage(
      Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        friendId: widget.friend.id,
        text: text,
        isMine: true,
        sentAt: DateTime.now(),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        title: Text(widget.friend.name),
        backgroundColor: Styles.background,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada pesan',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[_messages.length - 1 - i];
                          return ChatBubble(text: m.text, isMine: m.isMine);
                        },
                      ),
          ),
          MessageInput(onSend: _send),
        ],
      ),
    );
  }
}