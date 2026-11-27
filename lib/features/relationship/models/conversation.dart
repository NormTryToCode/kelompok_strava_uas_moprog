class Conversation {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final String lastSenderUid;
  final DateTime updatedAt;
  final Map<String, DateTime> readAt;

  const Conversation({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastSenderUid,
    required this.updatedAt,
    required this.readAt,
  });

  String peerUid(String myUid) =>
      participants.firstWhere((u) => u != myUid, orElse: () => myUid);

  bool isUnread(String myUid) {
    if (lastSenderUid.isEmpty || lastSenderUid == myUid) return false;
    final read = readAt[myUid];
    return read == null || read.isBefore(updatedAt);
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final rawRead = (json['readAt'] as Map<String, dynamic>?) ?? {};
    return Conversation(
      chatId: json['id'] as String,
      participants: (json['participants'] as List<dynamic>).cast<String>(),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastSenderUid: json['lastSenderUid'] as String? ?? '',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      readAt: rawRead.map((k, v) => MapEntry(k, DateTime.parse(v as String))),
    );
  }
}