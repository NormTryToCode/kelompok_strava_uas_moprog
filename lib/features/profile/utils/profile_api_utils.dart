import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/trophy_badge.dart';

Future<String> fetchIllustratorName(String badgeId) async {
  final response = await http.Client()
    .get(Uri.parse('https://api.tcgdex.net/v2/en/cards/$badgeId'));

    return compute(
      parseIllustratorName,
      response.body,
    );
}

String parseIllustratorName(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return (parsed['ilustrator'] as String?) ?? 'Strava Official Designer';
}

Future<List<TrophyBadge>>fetchTrophyBadgeData() async {
  final response = await http.Client()
    .get(Uri.parse('https://api.tcgdex.net/v2/en/sets/sv03.5'));

  return compute(
    parseTrophyBadges,
    response.body,
  );
}

List<TrophyBadge> parseTrophyBadges(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return parsed['cards']
    .map<TrophyBadge>((json) => TrophyBadge.fromJson(json))
    .toList();
}