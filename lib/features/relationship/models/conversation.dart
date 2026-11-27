class Conversation {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final String lastSenderUid;
  final DateTime updatedAt;

  const Conversation({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastSenderUid,
    required this.updatedAt,
  });

  String peerUid(String myUid) =>
      participants.firstWhere((u) => u != myUid, orElse: () => myUid);

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        chatId: json['id'] as String,
        participants: (json['participants'] as List<dynamic>).cast<String>(),
        lastMessage: json['lastMessage'] as String? ?? '',
        lastSenderUid: json['lastSenderUid'] as String? ?? '',
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}