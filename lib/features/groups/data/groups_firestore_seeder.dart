import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_challenges.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_events.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/dummy_races.dart';

class GroupsFirestoreSeeder {
  GroupsFirestoreSeeder._();

  static const _clubsCol = 'clubs';
  static const _eventsCol = 'events';
  static const _racesCol = 'races';
  static const _challengesCol = 'challenges';
  static const _userSeedsCol = 'groups_user_seeds';

  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  static final Map<String, Future<void>> _inFlight = {};
  static final Set<String> _seededInSession = {};

  static int _hashUid(String uid) =>
      uid.codeUnits.fold<int>(0, (acc, c) => (acc * 31 + c) & 0x7fffffff);

  static Future<void> ensureSeededForUser({
    required String uid,
    String? displayName,
  }) {
    if (_seededInSession.contains(uid)) return Future.value();
    return _inFlight.putIfAbsent(
      uid,
      () => _runSeedForUser(uid: uid)
          .timeout(const Duration(seconds: 10))
          .catchError((Object e, StackTrace st) {
            debugPrint('[GroupsSeeder] timeout/error: $e');
          })
          .whenComplete(() {
            _seededInSession.add(uid);
            _inFlight.remove(uid);
          }),
    );
  }

  static Future<void> _runSeedForUser({required String uid}) async {
    final seedDoc = await _firestore.collection(_userSeedsCol).doc(uid).get();
    if (seedDoc.exists) return;

    final snaps = await Future.wait([
      _firestore.collection(_clubsCol).limit(1).get(),
      _firestore.collection(_eventsCol).limit(1).get(),
      _firestore.collection(_racesCol).limit(1).get(),
      _firestore.collection(_challengesCol).limit(1).get(),
    ]);

    final batch = _firestore.batch();
    final baseClubs = buildDummyGroupClubs();
    final baseEvents = buildDummyEvents();
    final baseRaces = buildDummyRaces();
    final baseChallenges = buildDummyChallenges();

    if (snaps[0].docs.isEmpty) {
      for (final club in baseClubs) {
        final clean = club.copyWith(
          isOwner: false,
          isAdmin: false,
          isJoined: false,
        );
        batch.set(
          _firestore.collection(_clubsCol).doc(clean.id),
          clean.toJson(),
        );
      }
    }

    if (snaps[1].docs.isEmpty) {
      for (final event in baseEvents) {
        batch.set(
          _firestore.collection(_eventsCol).doc(event.id),
          event.toJson(),
        );
      }
    }

    if (snaps[2].docs.isEmpty) {
      for (final race in baseRaces) {
        batch.set(
          _firestore.collection(_racesCol).doc(race.id),
          race.toJson(),
        );
      }
    }

    if (snaps[3].docs.isEmpty) {
      for (final ch in baseChallenges) {
        batch.set(
          _firestore.collection(_challengesCol).doc(ch.id),
          ch.toJson(),
        );
      }
    }

    final h = _hashUid(uid);

    // 1. Relasi berbeda ke 2 klub komunitas
    final clubPicks = {
      baseClubs[h % baseClubs.length],
      baseClubs[(h + 3) % baseClubs.length],
    };
    for (final club in clubPicks) {
      batch.set(
        _firestore.collection(_clubsCol).doc(club.id),
        {'memberIds': FieldValue.arrayUnion([uid])},
        SetOptions(merge: true),
      );
    }

    // 2. Relasi berbeda ke 2 event
    final eventPicks = {
      baseEvents[h % baseEvents.length],
      baseEvents[(h + 5) % baseEvents.length],
    };
    for (final ev in eventPicks) {
      batch.set(
        _firestore.collection(_eventsCol).doc(ev.id),
        {'participantIds': FieldValue.arrayUnion([uid])},
        SetOptions(merge: true),
      );
    }

    // 3. Relasi berbeda ke 1 race
    final racePick = baseRaces[h % baseRaces.length];
    final tier = racePick.distanceTiers.isNotEmpty
        ? racePick.distanceTiers[h % racePick.distanceTiers.length].id
        : 'open';
    batch.set(
      _firestore.collection(_racesCol).doc(racePick.id),
      {
        'registrations': {uid: tier},
        'registeredCount': FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );

    // 4. Relasi berbeda ke 2 challenge
    final chPicks = {
      baseChallenges[h % baseChallenges.length],
      baseChallenges[(h + 2) % baseChallenges.length],
    };
    for (final ch in chPicks) {
      batch.set(
        _firestore.collection(_challengesCol).doc(ch.id),
        {
          'participantIds': FieldValue.arrayUnion([uid]),
          'participantCount': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    }

    batch.set(
      _firestore.collection(_userSeedsCol).doc(uid),
      {'uid': uid, 'seededAt': DateTime.now().toIso8601String()},
    );

    await batch.commit();
  }
}