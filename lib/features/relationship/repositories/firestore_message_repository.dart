import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/message.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/message_repository.dart';

class FirestoreMessageRepository implements MessageRepository {
  final _db = DatabaseService.instance;
  static MessageRepository instance = FirestoreMessageRepository();

  @override
  Future<List<Message>> getMessages(String friendId) async {
    final rows = await _db.getWhere('messages', 'friendId', friendId);
    final messages = rows.map(Message.fromJson).toList();
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return messages;
  }

  @override
  Future<void> addMessage(Message message) =>
      _db.save('messages', message.id, message.toJson());
}