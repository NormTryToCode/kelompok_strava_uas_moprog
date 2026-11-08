class Friend {
  final String id;
  final String name;
  final String username;

  const Friend({required this.id, required this.name, required this.username});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['id'] as String,
        name: json['name'] as String,
        username: json['username'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'username': username};
}