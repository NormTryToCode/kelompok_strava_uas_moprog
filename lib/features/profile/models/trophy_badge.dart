class TrophyBadge {
  final String id;
  final String image;
  final String localId;
  final String name;

  bool isChecked = false;

  TrophyBadge({
    required this.id,
    required this.image,
    required this.localId,
    required this.name,
  });

  String get imageLow => '$image/low.png';

  String get imageHigh => '$image/high.png';

  void toggleIsChecked() {
    isChecked = !isChecked;
  }

  factory TrophyBadge.fromJson(Map<String, dynamic> json) {
    return TrophyBadge(
      id: json['id'] as String, 
      image: json['image'] as String, 
      localId: json['localId'] as String, 
      name: json['name'] as String,
    );
  }
}
