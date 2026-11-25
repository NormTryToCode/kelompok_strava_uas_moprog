import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trophy_badge.dart';
import '../services/trophy_api_service.dart';

final trophyListProvider = FutureProvider<List<TrophyBadge>>((ref) async {
  return fetchTrophyBadgeData();
});

final claimedTrophiesProvider =
  NotifierProvider<ClaimedTrophiesNotifier, Set<String>>(
    ClaimedTrophiesNotifier.new,
);

class ClaimedTrophiesNotifier extends Notifier<Set<String>> {
  static const String _collection = 'athlete_trophies';
  static const String _docId = 'current_athlete';
  static const String _prefsKey = 'claimed_trophies';

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  StreamSubscription<List>? _firestoreSub;
  bool _isDisposed = false;

  @override
  Set<String> build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _firestoreSub?.cancel();
    });

    _loadLocalCache();
    _listenFirestore();
    return const <String>{};
  }

  Future<void> _loadLocalCache() async {
    try {
      final List<String> saved =
        await _asyncPrefs.getStringList(_prefsKey) ?? const [];
      if (_isDisposed) return;
      state = saved.toSet();
    } catch (_) {}
  }

  void _listenFirestore() {
    try {
      _firestoreSub = DatabaseService.instance.watch(_collection).listen(
        (docs) {
          if (_isDisposed) return;
          final matches = docs.where((d) => d['id'] == _docId);
          if (matches.isEmpty) return;

          final List<dynamic> rawIds =
            matches.first['claimedIds'] as List<dynamic>? ?? const [];
          state = rawIds.map((e) => e.toString()).toSet();
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> toggleClaim(String badgeId) async {
    final Set<String> updated = {...state};
    if (updated.contains(badgeId)) {
      updated.remove(badgeId);
    } else {
      updated.add(badgeId);
    }
    state = updated;

    await _asyncPrefs.setStringList(_prefsKey, updated.toList());
    try {
      await DatabaseService.instance.save(
        _collection,
        _docId,
        {
          'claimedIds': updated.toList(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (_) {}
  }
}