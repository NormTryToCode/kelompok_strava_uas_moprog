import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_firestore_seeder.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

class EventsNotifier extends AsyncNotifier<List<Event>> {
  EventRepository get _repository => ref.read(eventRepositoryProvider);
  String? get _currentUid => ref.read(authStateProvider).valueOrNull?.uid;

  @override
  Future<List<Event>> build() async {
    final user = ref.watch(authStateProvider).valueOrNull;
    final uid = user?.uid;
    if (uid != null && uid.isNotEmpty) {
      await GroupsFirestoreSeeder.ensureSeededForUser(
        uid: uid,
        displayName: user?.displayName ?? user?.email?.split('@').first,
      );
    }
    return _repository.getEvents(currentUid: uid);
  }

  Future<void> addEvent(Event event) async {
    final uid = _currentUid;
    final participants = (uid != null && !event.participantIds.contains(uid))
        ? [...event.participantIds, uid]
        : event.participantIds;
    final prepared = event.copyWith(
      participantIds: participants,
      attendeeCount: participants.length,
      isAttending: uid != null && participants.contains(uid),
    );

    await _repository.addEvent(prepared);
    final current = state.valueOrNull ?? const <Event>[];
    state = AsyncData([prepared, ...current]);
  }

  Future<void> toggleRsvp(String eventId) async {
    final uid = _currentUid;
    if (uid == null) return;

    final current = state.valueOrNull ?? const <Event>[];
    Event? updatedEvent;

    final nextList = <Event>[];
    for (final event in current) {
      if (event.id == eventId) {
        final joining = !event.participantIds.contains(uid);
        final nextParticipants = joining
            ? [...event.participantIds, uid]
            : event.participantIds.where((id) => id != uid).toList();
        updatedEvent = event.copyWith(
          isAttending: joining,
          participantIds: nextParticipants,
          attendeeCount: nextParticipants.length,
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