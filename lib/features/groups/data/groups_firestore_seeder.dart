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

  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  static Future<void>? _inFlight;
  static bool _seededInSession = false;

  /// Seed koleksi dasar (Clubs, Events, Races, Challenges) 1 kali saja jika
  /// masih kosong di Firestore. Tidak menambahkan relasi ke user yang login.
  static Future<void> ensureSeededForUser({
    required String uid,
    String? displayName,
  }) {
    return ensureSeeded();
  }

  static Future<void> ensureSeeded() {
    if (_seededInSession) return Future.value();
    return _inFlight ??= _runBaseSeed()
        .timeout(const Duration(seconds: 10))
        .catchError((Object e, StackTrace st) {
          debugPrint('[GroupsSeeder] timeout/error: $e');
        })
        .whenComplete(() {
          _seededInSession = true;
          _inFlight = null;
        });
  }

  static Future<void> _runBaseSeed() async {
    final snaps = await Future.wait([
      _firestore.collection(_clubsCol).limit(1).get(),
      _firestore.collection(_eventsCol).limit(1).get(),
      _firestore.collection(_racesCol).limit(1).get(),
      _firestore.collection(_challengesCol).limit(1).get(),
    ]);

    final needsClubs = snaps[0].docs.isEmpty;
    final needsEvents = snaps[1].docs.isEmpty;
    final needsRaces = snaps[2].docs.isEmpty;
    final needsChallenges = snaps[3].docs.isEmpty;

    if (!needsClubs && !needsEvents && !needsRaces && !needsChallenges) {
      return;
    }

    final batch = _firestore.batch();

    if (needsClubs) {
      for (final club in buildDummyGroupClubs()) {
        batch.set(
          _firestore.collection(_clubsCol).doc(club.id),
          club.toJson(),
        );
      }
    }

    if (needsEvents) {
      for (final event in buildDummyEvents()) {
        batch.set(
          _firestore.collection(_eventsCol).doc(event.id),
          event.toJson(),
        );
      }
    }

    if (needsRaces) {
      for (final race in buildDummyRaces()) {
        batch.set(
          _firestore.collection(_racesCol).doc(race.id),
          race.toJson(),
        );
      }
    }

    if (needsChallenges) {
      for (final ch in buildDummyChallenges()) {
        batch.set(
          _firestore.collection(_challengesCol).doc(ch.id),
          ch.toJson(),
        );
      }
    }

    await batch.commit();
  }
}