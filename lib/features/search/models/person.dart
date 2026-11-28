class Person {
  final String id;
  final String name;
  final String location;
  final String tag;
  final String? photoUrl;

  const Person({
    required this.id,
    required this.name,
    required this.location,
    required this.tag,
    this.photoUrl,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}