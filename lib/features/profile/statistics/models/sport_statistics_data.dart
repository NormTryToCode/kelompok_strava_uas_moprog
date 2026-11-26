import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';

class SportStatisticsData {
  final int sportIndex;
  final int weeklySessions;
  final int historicalBaseSessions;
  final double athleteWeightKg;

  const SportStatisticsData({
    required this.sportIndex,
    required this.weeklySessions,
    required this.historicalBaseSessions,
    this.athleteWeightKg = 74.0,
  });

  String get sportLabel {
    if (sportIndex == 0) return 'Cycling';
    if (sportIndex == 1) return 'Running';
    return 'Swimming';
  }

  String get sessionPluralLabel {
    if (sportIndex == 0) return 'Rides';
    if (sportIndex == 1) return 'Runs';
    return 'Swims';
  }

  bool get hasElevation => sportIndex != 2;

  String get distanceUnit => (sportIndex == 2) ? 'm' : 'km';

  int get _distancePerSession {
    if (sportIndex == 0) return 15;
    if (sportIndex == 1) return 3;
    return 400;
  }

  int get _minutesPerSession {
    if (sportIndex == 0) return 45;
    if (sportIndex == 1) return 20;
    return 30;
  }

  int get _elevationPerSession {
    if (sportIndex == 0) return 85;
    if (sportIndex == 1) return 12;
    return 0;
  }

  String get weeklyActivityCount => '$weeklySessions';

  String get weeklyDurationText =>
    _formatDuration(weeklySessions * _minutesPerSession);

  String get weeklyDistanceText {
    final int dist = weeklySessions * _distancePerSession;
    return '${dist.withThousands} $distanceUnit';
  }

  int get yearlyTotalSessions =>
    (weeklySessions == 0) ? 0 : (weeklySessions * 4);

  String get yearlyActivityCount => yearlyTotalSessions.withThousands;

  String get yearlyDurationText =>
    _formatDuration(yearlyTotalSessions * _minutesPerSession);

  int get yearlyDistanceValue => yearlyTotalSessions * _distancePerSession;

  String get yearlyDistanceText =>
    '${yearlyDistanceValue.withThousands} $distanceUnit';

  String get yearlyElevationText {
    final int elev = yearlyTotalSessions * _elevationPerSession;
    return '${elev.withThousands} m';
  }

  int get allTimeTotalSessions =>
    yearlyTotalSessions + (weeklySessions > 0 ? historicalBaseSessions : 0);

  String get allTimeActivityCount => allTimeTotalSessions.withThousands;

  String get allTimeDistanceText {
    final int totalDist = allTimeTotalSessions * _distancePerSession;
    return '${totalDist.withThousands} $distanceUnit';
  }

  int get annualTargetDistance {
    if (sportIndex == 0) return 300;
    if (sportIndex == 1) return 100;
    return 10000;
  }

  int get remainingTargetDistance =>
    (annualTargetDistance - yearlyDistanceValue).clamp(
      0,
      annualTargetDistance,
    );

  String get remainingTargetText {
    if (remainingTargetDistance <= 0) return 'Goal Surpassed';
    return '${remainingTargetDistance.withThousands} $distanceUnit to go';
  }

  double get annualProgressRatio {
    if (annualTargetDistance <= 0) return 0.0;
    final double ratio = yearlyDistanceValue / annualTargetDistance;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  int get estimatedCaloriesBurned {
    final double factor = (sportIndex == 0)
      ? 6.5
      : (sportIndex == 1)
        ? 3.2
        : 4.5;
    return (yearlyTotalSessions * athleteWeightKg * factor).round();
  }

  String get athleteLevelBadge {
    if (allTimeTotalSessions >= 25) return 'Apex Tier';
    if (allTimeTotalSessions >= 8) return 'Momentum Tier';
    if (allTimeTotalSessions >= 1) return 'Starter Tier';
    return 'Unranked';
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return '0h';
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}