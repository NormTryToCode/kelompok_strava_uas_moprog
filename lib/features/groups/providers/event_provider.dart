import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_firestore_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

class EventsNotifier extends AsyncNotifier<List<Event>> {
  EventRepository get _repository => ref.read(eventRepositoryProvider);

  @override
  Future<List<Event>> build() async {
    final stored = await _repository.getEvents();
    return GroupsFirestoreSeeder.seedMissingEvents(existing: stored);
  }

  Future<void> addEvent(Event event) async {
    await _repository.addEvent(event);
    final current = state.valueOrNull ?? const <Event>[];
    state = AsyncData([event, ...current]);
  }

  Future<void> toggleRsvp(String eventId) async {
    final current = state.valueOrNull ?? const <Event>[];
    Event? updatedEvent;

    final nextList = <Event>[];
    for (final event in current) {
      if (event.id == eventId) {
        final joining = !event.isAttending;
        final nextCount = joining
            ? event.attendeeCount + 1
            : (event.attendeeCount > 0 ? event.attendeeCount - 1 : 0);
        updatedEvent = event.copyWith(
          isAttending: joining,
          attendeeCount: nextCount,
        );
        nextList.add(updatedEvent);
      } else {
        nextList.add(event);
      }
    }

    if (updatedEvent == null) return;

    await _repository.updateEvent(updatedEvent);
    state = AsyncData(nextList);
  }

  Future<void> deleteEvent(String eventId) async {
    await _repository.deleteEvent(eventId);
    final current = state.valueOrNull ?? const <Event>[];
    state = AsyncData(current.where((e) => e.id != eventId).toList());
  }
}

final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<Event>>(
  EventsNotifier.new,
);