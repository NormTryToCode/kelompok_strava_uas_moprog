import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_events.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';

class GroupsFirestoreSeeder {
  GroupsFirestoreSeeder._();

  static const _eventsCollection = 'events';
  static final _db = DatabaseService.instance;

  static Future<List<Event>> seedEventsIfEmpty() async {
    final existing = await _db.getAll(_eventsCollection);
    if (existing.isNotEmpty) {
      return existing.map(Event.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final seeds = buildDummyEvents();
    await Future.wait([
      for (final event in seeds)
        _db.save(_eventsCollection, event.id, event.toJson()),
    ]);
    return seeds;
  }

  static Future<void> forceReseedEvents() async {
    final seeds = buildDummyEvents();
    await Future.wait([
      for (final event in seeds)
        _db.save(_eventsCollection, event.id, event.toJson()),
    ]);
  }
}