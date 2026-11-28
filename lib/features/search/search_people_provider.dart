import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

typedef AthleteJson = Map<String, dynamic>;
typedef AthleteReadAll = Future<List<AthleteJson>> Function(String collection);

final athleteReadAllProvider = Provider<AthleteReadAll>((ref) {
  return DatabaseService.instance.getAll;
});

Person? personFromAthleteDoc(AthleteJson doc) {
  final id = (doc['id'] as String? ?? '').trim();
  if (id.isEmpty) return null;
  final first = (doc['firstName'] as String? ?? '').trim();
  final last = (doc['lastName'] as String? ?? '').trim();
  final emailPrefix = (doc['email'] as String? ?? '').split('@').first.trim();
  final name = [first, last].where((s) => s.isNotEmpty).join(' ');
  final displayName = name.isNotEmpty
      ? name
      : (emailPrefix.isNotEmpty ? emailPrefix : 'Stride Athlete');

  final city = (doc['city'] as String? ?? '').trim();
  final country = (doc['country'] as String? ?? '').trim();
  final location = [city, country].where((s) => s.isNotEmpty).join(', ');

  final sport = (doc['primarySport'] as String? ?? '').trim();
  return Person(
    id: id,
    name: displayName,
    location: location.isEmpty ? 'Indonesia' : location,
    tag: sport.isEmpty ? 'Stride Athlete' : '$sport athlete',
  );
}

final searchPeopleAsyncProvider = FutureProvider<List<Person>>((ref) async {
  try {
    final reader = ref.watch(athleteReadAllProvider);
    final currentUid = resolveStorageUserId();
    final docs = await reader('athlete_profiles');
    final result = <Person>[];
    for (final doc in docs) {
      final person = personFromAthleteDoc(doc);
      if (person != null && person.id != currentUid) {
        result.add(person);
      }
    }
    return List.unmodifiable(result);
  } catch (_) {
    return const <Person>[];
  }
});

final searchPeopleProvider = Provider<List<Person>>((ref) {
  return ref.watch(searchPeopleAsyncProvider).valueOrNull ?? const <Person>[];
});