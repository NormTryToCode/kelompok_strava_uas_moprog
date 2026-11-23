class Message {
  final String id;
  final String friendId;
  final String text;
  final bool isMine;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.friendId,
    required this.text,
    required this.isMine,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        friendId: json['friendId'] as String,
        text: json['text'] as String,
        isMine: json['isMine'] as bool,
        sentAt: DateTime.parse(json['sentAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'friendId': friendId,
        'text': text,
        'isMine': isMine,
        'sentAt': sentAt.toIso8601String(),
      };
}