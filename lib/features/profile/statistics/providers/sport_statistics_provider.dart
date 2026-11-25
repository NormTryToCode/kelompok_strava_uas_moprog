import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SportSessionsState {
  final int rideSessions;
  final int runSessions;
  final int swimSessions;

  const SportSessionsState({
    this.rideSessions = 0,
    this.runSessions = 0,
    this.swimSessions = 0,
  });

  int sessionsForSport(int sportIndex) {
    if (sportIndex == 0) return rideSessions;
    if (sportIndex == 1) return runSessions;
    return swimSessions;
  }

  SportSessionsState copyWith({
    int? rideSessions,
    int? runSessions,
    int? swimSessions,
  }) {
    return SportSessionsState(
      rideSessions: rideSessions ?? this.rideSessions,
      runSessions: runSessions ?? this.runSessions,
      swimSessions: swimSessions ?? this.swimSessions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rideSessions': rideSessions,
      'runSessions': runSessions,
      'swimSessions': swimSessions,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory SportSessionsState.fromMap(Map<String, dynamic> map) {
    return SportSessionsState(
      rideSessions: (map['rideSessions'] as num?)?.toInt() ?? 0,
      runSessions: (map['runSessions'] as num?)?.toInt() ?? 0,
      swimSessions: (map['swimSessions'] as num?)?.toInt() ?? 0,
    );
  }
}

final sportStatisticsProvider =
  NotifierProvider<SportStatisticsNotifier, SportSessionsState>(
    SportStatisticsNotifier.new,
);

class SportStatisticsNotifier extends Notifier<SportSessionsState> {
  static const String _collection = 'athlete_stats';
  static const String _docId = 'current_athlete';

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  StreamSubscription<List>? _firestoreSub;
  bool _isDisposed = false;

  @override
  SportSessionsState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _firestoreSub?.cancel();
    });

    _loadLocalCache();
    _listenFirestore();
    return const SportSessionsState();
  }

  Future<void> _loadLocalCache() async {
    try {
      final int ride = await _asyncPrefs.getInt('stats_ride_sessions') ?? 0;
      final int run = await _asyncPrefs.getInt('stats_run_sessions') ?? 0;
      final int swim = await _asyncPrefs.getInt('stats_swim_sessions') ?? 0;

      if (_isDisposed) return;
      state = SportSessionsState(
        rideSessions: ride,
        runSessions: run,
        swimSessions: swim,
      );
    } catch (_) {}
  }

  void _listenFirestore() {
    try {
      _firestoreSub = DatabaseService.instance.watch(_collection).listen(
        (docs) {
          if (_isDisposed) return;
          final matches = docs.where((d) => d['id'] == _docId);
          if (matches.isEmpty) return;

          state = SportSessionsState.fromMap(matches.first);
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _persist(SportSessionsState nextState) async {
    state = nextState;

    await _asyncPrefs.setInt('stats_ride_sessions', nextState.rideSessions);
    await _asyncPrefs.setInt('stats_run_sessions', nextState.runSessions);
    await _asyncPrefs.setInt('stats_swim_sessions', nextState.swimSessions);

    try {
      await DatabaseService.instance.save(
        _collection,
        _docId,
        nextState.toMap(),
      );
    } catch (_) {}
  }

  Future<void> setSportSessions(int sportIndex, int newCount) async {
    final int clamped = newCount < 0 ? 0 : newCount;
    if (sportIndex == 0) {
      await _persist(state.copyWith(rideSessions: clamped));
    } else if (sportIndex == 1) {
      await _persist(state.copyWith(runSessions: clamped));
    } else {
      await _persist(state.copyWith(swimSessions: clamped));
    }
  }

  Future<void> incrementRun({int? maxLimit}) async {
    if (maxLimit != null && state.runSessions >= maxLimit) return;
    await setSportSessions(1, state.runSessions + 1);
  }

  Future<void> decrementRun() async {
    if (state.runSessions <= 0) return;
    await setSportSessions(1, state.runSessions - 1);
  }

  Future<void> resetRun() async {
    await setSportSessions(1, 0);
  }
}