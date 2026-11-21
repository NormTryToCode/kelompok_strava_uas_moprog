import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistoryNotifier extends Notifier<List<String>> {
  SearchHistoryNotifier({
    List<String>? initial,
    this.maxItems = 8,
  }) : _initial = List.unmodifiable(initial ?? const <String>[]);

  final List<String> _initial;
  final int maxItems;

  @override
  List<String> build() => _initial;

  void add(String query) {
    final value = query.trim();
    if (value.isEmpty) return;
    final next = [
      value,
      for (final item in state)
        if (item.toLowerCase() != value.toLowerCase()) item,
    ];
    state = List.unmodifiable(
      next.length > maxItems ? next.sublist(0, maxItems) : next,
    );
  }

  void remove(String query) {
    if (!state.contains(query)) return;
    state = List.unmodifiable(state.where((item) => item != query));
  }

  void clear() {
    if (state.isEmpty) return;
    state = const <String>[];
  }
}

final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(
  SearchHistoryNotifier.new,
);