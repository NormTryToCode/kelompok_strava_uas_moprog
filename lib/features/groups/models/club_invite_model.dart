class ClubInvite {
  final String clubId;
  final String friendId;
  final String friendName;
  final String username;
  final DateTime invitedAt;

  const ClubInvite({
    required this.clubId,
    required this.friendId,
    required this.friendName,
    required this.username,
    required this.invitedAt,
  });

  Map<String, dynamic> toJson() => {
        'clubId': clubId,
        'friendId': friendId,
        'friendName': friendName,
        'username': username,
        'invitedAt': invitedAt.toIso8601String(),
      };

  factory ClubInvite.fromJson(Map<String, dynamic> json) {
    return ClubInvite(
      clubId: json['clubId'] as String? ?? '',
      friendId: json['friendId'] as String? ?? '',
      friendName: json['friendName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      invitedAt: DateTime.tryParse(json['invitedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}