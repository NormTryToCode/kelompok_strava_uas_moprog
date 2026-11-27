import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_store.dart';

final searchHistoryStoreProvider = Provider<SearchHistoryStore>((ref) {
  return FirestoreSearchHistoryStore();
});

class SearchHistoryNotifier extends Notifier<List<String>> {
  SearchHistoryNotifier({
    List<String>? initial,
    this.maxItems = 8,
  }) : _initial = List.unmodifiable(initial ?? const <String>[]);

  final List<String> _initial;
  final int maxItems;

  SearchHistoryStore get _store => ref.read(searchHistoryStoreProvider);

  @override
  List<String> build() => _initial;

  Future<void> load() async {
    try {
      final stored = await _store.read();
      final trimmed =
          stored.length > maxItems ? stored.sublist(0, maxItems) : stored;
      state = List.unmodifiable(trimmed);
    } catch (_) {
      return;
    }
  }

  void add(String query) {
    final value = query.trim();
    if (value.isEmpty) return;
    final next = [
      value,
      for (final item in state)
        if (item.toLowerCase() != value.toLowerCase()) item,
    ];
    final limited = next.length > maxItems ? next.sublist(0, maxItems) : next;
    state = List.unmodifiable(limited);
    unawaited(_persist(limited));
  }

  void remove(String query) {
    if (!state.contains(query)) return;
    final next = state.where((item) => item != query).toList();
    state = List.unmodifiable(next);
    unawaited(_persist(next));
  }

  void clear() {
    if (state.isEmpty) return;
    state = const <String>[];
    unawaited(_persist(const <String>[]));
  }

  Future<void> _persist(List<String> items) async {
    try {
      await _store.write(items);
    } catch (_) {
      return;
    }
  }
}

final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(
  SearchHistoryNotifier.new,
);