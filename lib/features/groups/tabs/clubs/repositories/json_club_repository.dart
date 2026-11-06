import 'dart:convert';
import 'dart:io';

import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/repositories/club_repository.dart';
import 'package:path_provider/path_provider.dart';

class JsonClubRepository implements ClubRepository {
  static const _fileName = 'clubs.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  @override
  Future<List<Club>> getClubs() async {
    final file = await _file();
    if (!await file.exists()) return [];

    try {
      final data = jsonDecode(await file.readAsString());
      final list = data is Map ? data['clubs'] : null;
      if (list is! List) return [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Club.fromJson)
          .toList();
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> addClub(Club club) async {
    final clubs = await getClubs();
    await _write([club, ...clubs]); 
  }

  Future<void> _write(List<Club> clubs) async {
    final file = await _file();
    final temp = File('${file.path}.tmp');
    final content = const JsonEncoder.withIndent('  ').convert({
      'clubs': clubs.map((c) => c.toJson()).toList(),
    });

    await temp.writeAsString(content, flush: true);
    await temp.rename(file.path);
  }
}
