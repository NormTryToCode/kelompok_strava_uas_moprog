class StatItem {
  final double todayKm;
  final double totalCalories;
  final int heartRate;        
  final double averagePace;   
  final int activeMinutes;    

  const StatItem({
    required this.todayKm,
    required this.totalCalories,
    required this.heartRate,
    required this.averagePace,
    this.activeMinutes = 0,
  });
}

