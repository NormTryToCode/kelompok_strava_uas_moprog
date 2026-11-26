class UserProfile {
  final String uid;
  final String name;
  final String username;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.username,
  });

  // json = dokumen athlete_profiles (+ 'id' dari DatabaseService.getAll)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final first = (json['firstName'] as String? ?? '').trim();
    final last = (json['lastName'] as String? ?? '').trim();
    final email = json['email'] as String? ?? '';
    final handle =
        email.contains('@') ? email.split('@').first.toLowerCase() : '';
    final name = [first, last].where((s) => s.isNotEmpty).join(' ');
    return UserProfile(
      uid: json['id'] as String,
      name: name.isEmpty ? handle : name,
      username: handle,
    );
  }
}