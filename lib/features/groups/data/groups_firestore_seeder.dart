import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_events.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';

class GroupsFirestoreSeeder {
  GroupsFirestoreSeeder._();

  static const _clubsCollection = 'clubs';
  static const _eventsCollection = 'events';
  static final _db = DatabaseService.instance;

  static Future<List<Club>> seedMissingClubs({List<Club>? existing}) async {
    final current = existing ??
        (await _db.getAll(_clubsCollection)).map(Club.fromJson).toList();

    try {
      final existingIds = {for (final club in current) club.id};
      final missing = buildDummyGroupClubs()
          .where((seed) => !existingIds.contains(seed.id))
          .toList();

      if (missing.isEmpty) return current;

      debugPrint('[Seeder] Inserting ${missing.length} missing clubs...');
      for (final club in missing) {
        await _db.save(_clubsCollection, club.id, club.toJson());
      }
      debugPrint('[Seeder] Done inserting missing clubs.');

      return [...current, ...missing]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e, st) {
      debugPrint('[Seeder] seedMissingClubs FAILED: $e\n$st');
      return current;
    }
  }

  static Future<List<Event>> seedMissingEvents({List<Event>? existing}) async {
    final current = existing ??
        (await _db.getAll(_eventsCollection)).map(Event.fromJson).toList();

    try {
      final existingIds = {for (final event in current) event.id};
      final missing = buildDummyEvents()
          .where((seed) => !existingIds.contains(seed.id))
          .toList();

      if (missing.isEmpty) return current;

      debugPrint('[Seeder] Inserting ${missing.length} missing events...');
      for (final event in missing) {
        await _db.save(_eventsCollection, event.id, event.toJson());
      }
      debugPrint('[Seeder] Done inserting missing events.');

      return [...current, ...missing]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e, st) {
      debugPrint('[Seeder] seedMissingEvents FAILED: $e\n$st');
      return current;
    }
  }
}