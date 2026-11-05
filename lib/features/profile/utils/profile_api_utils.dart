import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/trophy_badge.dart';

const String _stravaMilestonesJson = '''
{
  "milestones": [
    {"id": "m1", "title": "Aktivitas Pertama", "watermarkNumber": "1", "requiredActivities": 1, "description": "Menyelesaikan rekaman aktivitas olahraga pertama Anda di Strava."},
    {"id": "m3", "title": "Aktivitas Ketiga", "watermarkNumber": "3", "requiredActivities": 3, "description": "Konsistensi awal! Menyelesaikan 3 aktivitas olahraga."},
    {"id": "m5", "title": "Aktivitas Kelima", "watermarkNumber": "5", "requiredActivities": 5, "description": "Membangun kebiasaan sehat dengan 5 aktivitas tercatat."},
    {"id": "m10", "title": "Aktivitas Ke10", "watermarkNumber": "10", "requiredActivities": 10, "description": "Mencapai dua digit pertama dengan total 10 aktivitas."},
    {"id": "m20", "title": "Aktivitas Ke20", "watermarkNumber": "20", "requiredActivities": 20, "description": "Dedikasi penuh! Menyelesaikan 20 sesi latihan."},
    {"id": "m30", "title": "Aktivitas Ke30", "watermarkNumber": "30", "requiredActivities": 30, "description": "Satu bulan penuh konsistensi dengan 30 aktivitas."},
    {"id": "m40", "title": "Aktivitas Ke40", "watermarkNumber": "40", "requiredActivities": 40, "description": "Melampaui batas dengan 40 aktivitas olahraga tercatat."},
    {"id": "m50", "title": "Aktivitas Ke50", "watermarkNumber": "50", "requiredActivities": 50, "description": "Setengah jalan menuju seratus! 50 aktivitas selesai."},
    {"id": "m75", "title": "Aktivitas Ke75", "watermarkNumber": "75", "requiredActivities": 75, "description": "Atlet disiplin dengan 75 rekaman aktivitas."},
    {"id": "m100", "title": "Aktivitas Ke100", "watermarkNumber": "100", "requiredActivities": 100, "description": "Klub Seratus! Mencapai tonggak bersejarah 100 aktivitas."},
    {"id": "m150", "title": "Aktivitas Ke150", "watermarkNumber": "150", "requiredActivities": 150, "description": "Ketahanan luar biasa dengan total 150 aktivitas."},
    {"id": "m200", "title": "Aktivitas Ke200", "watermarkNumber": "200", "requiredActivities": 200, "description": "Dua ratus sesi latihan berhasil ditaklukkan."},
    {"id": "m250", "title": "Aktivitas Ke250", "watermarkNumber": "250", "requiredActivities": 250, "description": "Seperempat ribu aktivitas tercatat di profil Anda."},
    {"id": "m300", "title": "Aktivitas Ke300", "watermarkNumber": "300", "requiredActivities": 300, "description": "Level atlet veteran dengan 300 aktivitas olahraga."},
    {"id": "m400", "title": "Aktivitas Ke400", "watermarkNumber": "400", "requiredActivities": 400, "description": " Empat ratus aktivitas! Inspirasi bagi komunitas lari."},
    {"id": "m500", "title": "Aktivitas Ke500", "watermarkNumber": "500", "requiredActivities": 500, "description": "Setengah ribu aktivitas! Pencapaian elit Strava."},
    {"id": "m600", "title": "Aktivitas Ke600", "watermarkNumber": "600", "requiredActivities": 600, "description": "Enam ratus sesi latihan tanpa kenal lelah."},
    {"id": "m700", "title": "Aktivitas Ke700", "watermarkNumber": "700", "requiredActivities": 700, "description": "Legenda Strava! Menuntaskan 700 aktivitas olahraga."}
  ]
}
''';

Future<List<TrophyBadge>> fetchTrophyBadgeData() async {
  return compute(
    parseTrophyBadges,
    _stravaMilestonesJson,
  );
}

List<TrophyBadge> parseTrophyBadges(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return parsed['milestones']
      .map<TrophyBadge>((json) => TrophyBadge.fromJson(json))
      .toList();
}