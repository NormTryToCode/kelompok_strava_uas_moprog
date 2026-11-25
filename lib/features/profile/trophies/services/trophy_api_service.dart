import 'dart:convert';
import '../models/trophy_badge.dart';

const String _strideMilestonesJson = '''
{
  "milestones": [
    {"id": "m1", "title": "First Spark", "watermarkNumber": "1", "requiredActivities": 1, "tier": "Initiate", "description": "Completed your inaugural tracked session and ignited your Stride journey."},
    {"id": "m3", "title": "Rhythm Starter", "watermarkNumber": "3", "requiredActivities": 3, "tier": "Initiate", "description": "Built early velocity by logging 3 dedicated athletic sessions."},
    {"id": "m5", "title": "Habit Forged", "watermarkNumber": "5", "requiredActivities": 5, "tier": "Initiate", "description": "Locked in a lasting training routine across 5 completed sessions."},
    {"id": "m10", "title": "Double Digits", "watermarkNumber": "10", "requiredActivities": 10, "tier": "Initiate", "description": "Entered double-digit territory with 10 workouts etched in your journal."},
    {"id": "m20", "title": "Stride Regular", "watermarkNumber": "20", "requiredActivities": 20, "tier": "Momentum", "description": "Demonstrated unwavering consistency across 20 training sessions."},
    {"id": "m30", "title": "30-Session Flow", "watermarkNumber": "30", "requiredActivities": 30, "tier": "Momentum", "description": "Mastered a full monthly rhythm with 30 completed workouts."},
    {"id": "m40", "title": "Trail Blazer", "watermarkNumber": "40", "requiredActivities": 40, "tier": "Momentum", "description": "Pushed past every comfort zone with 40 logged sessions."},
    {"id": "m50", "title": "Half-Century", "watermarkNumber": "50", "requiredActivities": 50, "tier": "Momentum", "description": "Reached the 50-session mark—halfway to the iconic Century Club."},
    {"id": "m75", "title": "Iron Discipline", "watermarkNumber": "75", "requiredActivities": 75, "tier": "Vanguard", "description": "Showcased elite grit and consistency across 75 sessions."},
    {"id": "m100", "title": "Centurion Crest", "watermarkNumber": "100", "requiredActivities": 100, "tier": "Vanguard", "description": "Joined the Centurion ranks by completing 100 tracked sessions."},
    {"id": "m150", "title": "Endurance Core", "watermarkNumber": "150", "requiredActivities": 150, "tier": "Vanguard", "description": "Forged unstoppable stamina across 150 training workouts."},
    {"id": "m200", "title": "Double Century", "watermarkNumber": "200", "requiredActivities": 200, "tier": "Vanguard", "description": "Conquered 200 athletic sessions of pure forward momentum."},
    {"id": "m250", "title": "Quarter Millennial", "watermarkNumber": "250", "requiredActivities": 250, "tier": "Titan", "description": "Etched 250 completed sessions into your permanent Stride Passport."},
    {"id": "m300", "title": "Veteran Pulse", "watermarkNumber": "300", "requiredActivities": 300, "tier": "Titan", "description": "Achieved veteran athlete standing with 300 logged workouts."},
    {"id": "m400", "title": "Peak Vanguard", "watermarkNumber": "400", "requiredActivities": 400, "tier": "Titan", "description": "Four hundred sessions strong—setting the pace for the entire pack."},
    {"id": "m500", "title": "Titan 500", "watermarkNumber": "500", "requiredActivities": 500, "tier": "Mythic", "description": "Half a thousand sessions logged! Reserved for true Stride titans."},
    {"id": "m600", "title": "Relentless Force", "watermarkNumber": "600", "requiredActivities": 600, "tier": "Mythic", "description": "Six hundred sessions conquered without ever losing your edge."},
    {"id": "m700", "title": "Stride Legend", "watermarkNumber": "700", "requiredActivities": 700, "tier": "Mythic", "description": "Immortalized in the Trophy Vault with 700 completed sessions."}
  ]
}
''';

Future<List<TrophyBadge>> fetchTrophyBadgeData() async {
  return parseTrophyBadges(_strideMilestonesJson);
}

List<TrophyBadge> parseTrophyBadges(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return (parsed['milestones'] as List<dynamic>)
    .map<TrophyBadge>(
      (json) => TrophyBadge.fromJson(json as Map<String, dynamic>),
    )
    .toList();
}