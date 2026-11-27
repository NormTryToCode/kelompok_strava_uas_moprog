import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';

class EventRepository {
  final _db = DatabaseService.instance;

  Future<List<Event>> getEvents({String? currentUid}) async {
    final events = (await _db.getAll('events'))
        .map((row) => Event.fromJson(row, currentUid: currentUid))
        .toList();
    events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events;
  }

  Future<void> addEvent(Event event) =>
      _db.save('events', event.id, event.toJson());

  Future<void> updateEvent(Event event) =>
      _db.save('events', event.id, event.toJson());

  Future<void> deleteEvent(String eventId) => _db.remove('events', eventId);
}