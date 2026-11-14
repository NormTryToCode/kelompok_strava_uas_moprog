import 'package:flutter/foundation.dart';

class SearchHistoryController extends ChangeNotifier {
  SearchHistoryController({List<String>? initial, this.maxItems = 8})
      : _items = [...?initial];

  static final SearchHistoryController instance = SearchHistoryController();

  final int maxItems;
  final List<String> _items;

  List<String> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  void add(String query) {
    final value = query.trim();
    if (value.isEmpty) return;
    _items.removeWhere((e) => e.toLowerCase() == value.toLowerCase());
    _items.insert(0, value);
    if (_items.length > maxItems) {
      _items.removeRange(maxItems, _items.length);
    }
    notifyListeners();
  }

  void remove(String query) {
    if (_items.remove(query)) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}