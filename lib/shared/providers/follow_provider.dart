import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const <String>{};

  bool isFollowing(String id) => state.contains(id);

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
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