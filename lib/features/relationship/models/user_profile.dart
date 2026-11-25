class UserProfile {
  final String uid;
  final String name;
  final String username;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.username,
  });

  // 'id' diisi DatabaseService.getAll dari ID dokumen (= uid)
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        uid: json['id'] as String,
        name: json['name'] as String,
        username: json['username'] as String,
      );

  Map<String, dynamic> toJson() => {'name': name, 'username': username};
}