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
    if (sportIndex == 0) return 'Bersepeda';
    if (sportIndex == 1) return 'Berlari';
    return 'Berenang';
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
    if (allTimeTotalSessions >= 25) return 'Atlet Elit Strava';
    if (allTimeTotalSessions >= 8) return 'Atlet Aktif';
    if (allTimeTotalSessions >= 1) return 'Atlet Pemula';
    return 'Belum Ada Rekaman';
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return '0j';
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}j';
    return '${hours}j ${minutes}m';
  }
}