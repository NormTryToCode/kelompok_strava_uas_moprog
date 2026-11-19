import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/json_event_repository.dart';

abstract class EventRepository {
  static EventRepository instance = JsonEventRepository();

  Future<List<Event>> getEvents();

  Future<void> addEvent(Event event);
}
