import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/chat_message.dart';

class ChatRepository {
  static ChatRepository instance = ChatRepository();
  final _db = DatabaseService.instance;

  // chatId DM = dua uid yang diurutkan, supaya sama dari kedua sisi
  static String dmChatId(String uidA, String uidB) {
    final ids = [uidA, uidB]..sort();
    return ids.join('_');
  }

  String _path(String chatId) => 'chats/$chatId/messages';

  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _db.watch(_path(chatId)).map((rows) {
      final messages = rows.map(ChatMessage.fromJson).toList();
      messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      return messages;
    });
  }

  Future<void> sendMessage(String chatId, String text) {
    final me = FirebaseAuth.instance.currentUser!.uid;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final message = ChatMessage(
      id: id,
      senderUid: me,
      text: text,
      sentAt: DateTime.now(),
    );
    return _db.save(_path(chatId), id, message.toJson());
  }
}