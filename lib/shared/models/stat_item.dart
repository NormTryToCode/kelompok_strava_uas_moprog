class StatItem {
  final double todayKm;
  final double totalCalories;
  final int heartRate;        // BPM is usually a whole number
  final double averagePace;   // e.g., 5.5 (minutes per km)
  final int activeMinutes;    // Moving time in minutes

  const StatItem({
    required this.todayKm,
    required this.totalCalories,
    required this.heartRate,
    required this.averagePace,
    this.activeMinutes = 0,
  });
}

