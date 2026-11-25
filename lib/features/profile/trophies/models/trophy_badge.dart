class TrophyBadge {
  final String id;
  final String title;
  final String watermarkNumber;
  final int requiredActivities;
  final String description;

  bool isChecked = false;

  TrophyBadge({
    required this.id,
    required this.title,
    required this.watermarkNumber,
    required this.requiredActivities,
    required this.description,
  });

  void toggleIsChecked() {
    isChecked = !isChecked;
  }

  factory TrophyBadge.fromJson(Map<String, dynamic> json) {
    return TrophyBadge(
      id: json['id'] as String,
      title: json['title'] as String,
      watermarkNumber: json['watermarkNumber'] as String,
      requiredActivities: json['requiredActivities'] as int,
      description: json['description'] as String,
    );
  }
}