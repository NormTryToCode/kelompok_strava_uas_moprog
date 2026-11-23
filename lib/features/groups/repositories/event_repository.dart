import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';

class EventRepository {
  final _db = DatabaseService.instance;

  Future<List<Event>> getEvents() async {
    final events = (await _db.getAll('events')).map(Event.fromJson).toList();
    events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events;
  }

  Future<void> addEvent(Event event) =>
      _db.save('events', event.id, event.toJson());

  Future<void> updateEvent(Event event) =>
      _db.save('events', event.id, event.toJson());

  Future<void> deleteEvent(String eventId) => _db.remove('events', eventId);
}