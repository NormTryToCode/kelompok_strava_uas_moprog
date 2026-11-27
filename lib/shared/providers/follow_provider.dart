import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_store.dart';

final followStoreProvider = Provider<FollowStore>((ref) {
  return FirestoreFollowStore();
});

class FollowNotifier extends Notifier<Set<String>> {
  FollowStore get _store => ref.read(followStoreProvider);

  @override
  Set<String> build() => const <String>{};

  bool isFollowing(String id) => state.contains(id);

  Future<void> load() async {
    try {
      final stored = await _store.read();
      state = Set.unmodifiable(stored);
    } catch (_) {
      return;
    }
  }

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) {
      next.add(id);
    }
    state = Set.unmodifiable(next);
    unawaited(_persist(next));
  }

  Future<void> _persist(Set<String> ids) async {
    try {
      await _store.write(ids);
    } catch (_) {
      return;
    }
  }
}

final followProvider = NotifierProvider<FollowNotifier, Set<String>>(
  FollowNotifier.new,
);

final followingCountProvider = Provider<int>((ref) {
  return ref.watch(followProvider).length;
});

final isFollowingProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(followProvider).contains(id);
});