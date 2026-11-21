import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/local_json_store.dart';

class EventRepository {
  final _store = LocalJsonStore<Event>(
    fileName: 'events.json',
    rootKey: 'events',
    fromJson: Event.fromJson,
    toJson: (e) => e.toJson(),
  );

  Future<List<Event>> getEvents() => _store.readAll();

  Future<void> addEvent(Event event) async {
    final events = await _store.readAll();
    await _store.writeAll([event, ...events]);
  }

  Future<void> updateEvent(Event event) async {
    final events = await _store.readAll();
    await _store.writeAll([
      for (final item in events)
        if (item.id == event.id) event else item,
    ]);
  }

  Future<void> deleteEvent(String eventId) async {
    final events = await _store.readAll();
    await _store.writeAll(events.where((e) => e.id != eventId).toList());
  }
}