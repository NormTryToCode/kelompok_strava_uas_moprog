import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_events.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_group_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';

class GroupsFirestoreSeeder {
  GroupsFirestoreSeeder._();

  static const _eventsCollection = 'events';
  static const _clubsCollection = 'clubs';
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

  static Future<List<Club>> seedClubsIfEmpty() async {
    final existingRows = await _db.getAll(_clubsCollection);
    final existingClubs = existingRows.map(Club.fromJson).toList();
    final hasSeededClubs = existingClubs.any((c) => c.id.startsWith('club'));

    if (hasSeededClubs) {
      existingClubs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return existingClubs;
    }

    final seeds = buildDummyGroupClubs();
    await Future.wait([
      for (final club in seeds)
        _db.save(_clubsCollection, club.id, club.toJson()),
    ]);

    final combined = [...existingClubs, ...seeds]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return combined;
  }

  static Future<void> forceReseedClubs() async {
    final seeds = buildDummyGroupClubs();
    await Future.wait([
      for (final club in seeds)
        _db.save(_clubsCollection, club.id, club.toJson()),
    ]);
  }
}