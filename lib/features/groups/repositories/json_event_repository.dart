import 'dart:convert';
import 'dart:io';

import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';
import 'package:path_provider/path_provider.dart';

class JsonEventRepository implements EventRepository {
  static const _fileName = 'events.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  @override
  Future<List<Event>> getEvents() async {
    final file = await _file();
    if (!await file.exists()) return [];

    try {
      final data = jsonDecode(await file.readAsString());
      final list = data is Map ? data['events'] : null;
      if (list is! List) return [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(Event.fromJson)
          .toList();
    } on FormatException {
      return [];
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    final events = await getEvents();
    await _write([event, ...events]);
  }

  Future<void> _write(List<Event> events) async {
    final file = await _file();
    final temp = File('${file.path}.tmp');
    final content = const JsonEncoder.withIndent('  ').convert({
      'events': events.map((e) => e.toJson()).toList(),
    });

    await temp.writeAsString(content, flush: true);
    await temp.rename(file.path);
  }
}
