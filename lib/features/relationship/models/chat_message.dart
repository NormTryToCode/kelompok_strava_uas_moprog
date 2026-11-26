class ChatMessage {
  final String id;
  final String senderUid;
  final String text;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.senderUid,
    required this.text,
    required this.sentAt,
  });

  bool isMine(String myUid) => senderUid == myUid;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        senderUid: json['senderUid'] as String,
        text: json['text'] as String,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'senderUid': senderUid,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
      };
}