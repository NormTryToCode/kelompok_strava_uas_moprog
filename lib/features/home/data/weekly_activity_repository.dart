import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/home/models/weekly_activity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef WeeklyJsonMap = Map<String, dynamic>;
typedef WeeklyReadByUser = Future<List<WeeklyJsonMap>> Function(
  String collection,
  String field,
  Object value,
);
typedef WeeklySaveDoc = Future<void> Function(
  String collection,
  String id,
  WeeklyJsonMap data, {
  bool merge,
});

/// Storage contract for reading and updating weekly activity summaries.
abstract class WeeklyActivityStore {
  Future<WeeklyActivityData?> fetchWeek({
    required String userId,
    required DateTime referenceDate,
  });

  Future<void> saveWeek(WeeklyActivityData data);

  Future<WeeklyActivityData> addActivityMetrics({
    required String userId,
    required DateTime date,
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
  });
}

/// Firestore-backed weekly activity repository with local SharedPreferences fallback.
class FirestoreWeeklyActivityRepository implements WeeklyActivityStore {
  static const String collectionName = 'weekly_activities';
  static const String _prefsPrefix = 'weekly_activity_cache_';

  final WeeklyReadByUser _readByUser;
  final WeeklySaveDoc _saveDoc;
  SharedPreferencesAsync? _prefsCache;

  FirestoreWeeklyActivityRepository({
    WeeklyReadByUser? readByUser,
    WeeklySaveDoc? saveDoc,
    SharedPreferencesAsync? prefs,
  })  : _readByUser = readByUser ?? DatabaseService.instance.getWhere,
        _saveDoc = saveDoc ?? DatabaseService.instance.save,
        _prefsCache = prefs;

  SharedPreferencesAsync get _prefs => _prefsCache ??= SharedPreferencesAsync();

  @override
  Future<WeeklyActivityData?> fetchWeek({
    required String userId,
    required DateTime referenceDate,
  }) async {
    final docId = WeeklyActivityData.buildDocId(
      userId: userId,
      referenceDate: referenceDate,
    );
    final weekStart = WeeklyActivityData.formatDateIso(
      WeeklyActivityData.mondayOfWeek(referenceDate),
    );

    try {
      final docs = await _readByUser(collectionName, 'userId', userId);
      for (final doc in docs) {
        if (doc['id'] == docId || doc['weekStartDate'] == weekStart) {
          final parsed = WeeklyActivityData.fromJson(doc, id: docId);
          await _writeLocalCache(parsed);
          return parsed;
        }
      }
      return null;
    } catch (e) {
      debugPrint('WeeklyActivityRepository: Firestore fetch failed: $e');
      return _readLocalCache(docId);
    }
  }

  @override
  Future<void> saveWeek(WeeklyActivityData data) async {
    await _writeLocalCache(data);
    try {
      await _saveDoc(
        collectionName,
        data.id,
        data.toJson(),
        merge: true,
      );
    } catch (e) {
      debugPrint('WeeklyActivityRepository: Firestore save failed: $e');
    }
  }

  @override
  Future<WeeklyActivityData> addActivityMetrics({
    required String userId,
    required DateTime date,
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
  }) async {
    final current = await fetchWeek(userId: userId, referenceDate: date) ??
        WeeklyActivityData.empty(userId: userId, referenceDate: date);
    final updated = current.withAddedMetrics(
      date: date,
      distanceKm: distanceKm,
      calories: calories,
      steps: steps,
      markUnseeded: true,
    );
    await saveWeek(updated);
    return updated;
  }

  Future<WeeklyActivityData?> _readLocalCache(String docId) async {
    try {
      final raw = await _prefs.getString('$_prefsPrefix$docId');
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return WeeklyActivityData.fromJson(
        Map<String, dynamic>.from(decoded),
        id: docId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeLocalCache(WeeklyActivityData data) async {
    try {
      await _prefs.setString(
        '$_prefsPrefix${data.id}',
        jsonEncode(data.toJson()),
      );
    } catch (_) {
      return;
    }
  }
}

/// In-memory weekly activity repository for unit and widget tests.
class MemoryWeeklyActivityRepository implements WeeklyActivityStore {
  final Map<String, WeeklyActivityData> _weeks = {};

  @override
  Future<WeeklyActivityData?> fetchWeek({
    required String userId,
    required DateTime referenceDate,
  }) async {
    final docId = WeeklyActivityData.buildDocId(
      userId: userId,
      referenceDate: referenceDate,
    );
    return _weeks[docId];
  }

  @override
  Future<void> saveWeek(WeeklyActivityData data) async {
    _weeks[data.id] = data;
  }

  @override
  Future<WeeklyActivityData> addActivityMetrics({
    required String userId,
    required DateTime date,
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
  }) async {
    final current = await fetchWeek(userId: userId, referenceDate: date) ??
        WeeklyActivityData.empty(userId: userId, referenceDate: date);
    final updated = current.withAddedMetrics(
      date: date,
      distanceKm: distanceKm,
      calories: calories,
      steps: steps,
      markUnseeded: true,
    );
    await saveWeek(updated);
    return updated;
  }
}
