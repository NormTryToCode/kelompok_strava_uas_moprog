import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/message.dart';

abstract class MessageRepository {
  static MessageRepository instance = PrefsMessageRepository();

  Future<List<Message>> getMessages(String friendId);
  Future<void> addMessage(Message message);
}

class PrefsMessageRepository implements MessageRepository {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  String _key(String friendId) => 'messages_$friendId';

  @override
  Future<List<Message>> getMessages(String friendId) async {
    final raw = await _prefs.getString(_key(friendId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addMessage(Message message) async {
    final messages = await getMessages(message.friendId);
    final updated = [...messages, message];
    await _prefs.setString(
      _key(message.friendId),
      jsonEncode(updated.map((m) => m.toJson()).toList()),
    );
  }
}