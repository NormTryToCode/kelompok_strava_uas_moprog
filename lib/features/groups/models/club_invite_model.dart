class ClubInvite {
  final String clubId;
  final String clubName;
  final String friendId;
  final String friendName;
  final String username;
  final String invitedByName;
  final String status; // 'pending' | 'accepted' | 'rejected'
  final DateTime invitedAt;

  const ClubInvite({
    required this.clubId,
    required this.friendId,
    required this.friendName,
    required this.username,
    required this.invitedAt,
    this.clubName = '',
    this.invitedByName = 'Club Admin',
    this.status = 'pending',
  });

  bool get isPending => status == 'pending';

  Map<String, dynamic> toJson() => {
        'clubId': clubId,
        'clubName': clubName,
        'friendId': friendId,
        'friendName': friendName,
        'username': username,
        'invitedByName': invitedByName,
        'status': status,
        'invitedAt': invitedAt.toIso8601String(),
      };

  factory ClubInvite.fromJson(Map<String, dynamic> json) {
    return ClubInvite(
      clubId: json['clubId'] as String? ?? '',
      clubName: json['clubName'] as String? ?? '',
      friendId: json['friendId'] as String? ?? '',
      friendName: json['friendName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      invitedByName: json['invitedByName'] as String? ?? 'Club Admin',
      status: json['status'] as String? ?? 'pending',
      invitedAt: DateTime.tryParse(json['invitedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}