import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';

class ActivityState {
  final List<ManualActivity> items;
  final bool isLoaded;

  const ActivityState({
    this.items = const <ManualActivity>[],
    this.isLoaded = false,
  });

  int get count => items.length;

  double get totalDistanceKm =>
      items.fold<double>(0, (sum, item) => sum + item.distanceKm);
}

final activityStoreProvider = Provider<ActivityStore>((ref) {
  return FirestoreActivityStore();
});

class ActivityNotifier extends Notifier<ActivityState> {
  ActivityStore get _store => ref.read(activityStoreProvider);

  @override
  ActivityState build() => const ActivityState();

  Future<void> load() async {
    var items = <ManualActivity>[];
    try {
      final raw = await _store.read();
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        items = [
          for (final entry in decoded)
            ManualActivity.fromJson(entry as Map<String, dynamic>),
        ];
        items.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (_) {
      items = <ManualActivity>[];
    }
    state = ActivityState(items: List.unmodifiable(items), isLoaded: true);
  }

  Future<void> add(ManualActivity activity) async {
    final next = [
      ...state.items.where((item) => item.id != activity.id),
      activity,
    ]..sort((a, b) => b.date.compareTo(a.date));
    state = ActivityState(
      items: List.unmodifiable(next),
      isLoaded: state.isLoaded,
    );
    await _persist(next);
  }

  Future<void> remove(String id) async {
    final next = state.items.where((item) => item.id != id).toList();
    if (next.length == state.items.length) return;
    state = ActivityState(
      items: List.unmodifiable(next),
      isLoaded: state.isLoaded,
    );
    await _persist(next);
  }

  Future<void> _persist(List<ManualActivity> items) async {
    try {
      await _store.write(jsonEncode([for (final a in items) a.toJson()]));
    } catch (_) {
      return;
    }
  }
}

final activityProvider = NotifierProvider<ActivityNotifier, ActivityState>(
  ActivityNotifier.new,
);