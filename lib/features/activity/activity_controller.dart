import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';

class ActivityController extends ChangeNotifier {
  ActivityController({ActivityStore? store})
      : _store = store ?? PrefsActivityStore();

  static final ActivityController instance = ActivityController();

  final ActivityStore _store;
  List<ManualActivity> _items = [];
  bool _loaded = false;

  List<ManualActivity> get items => List.unmodifiable(_items);

  bool get isLoaded => _loaded;

  int get count => _items.length;

  double get totalDistanceKm =>
      _items.fold<double>(0, (sum, item) => sum + item.distanceKm);

  Future<void> load() async {
    try {
      final raw = await _store.read();
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _items = [
          for (final entry in decoded)
            ManualActivity.fromJson(entry as Map<String, dynamic>),
        ];
        _sortNewestFirst();
      }
    } catch (_) {
      _items = [];
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(ManualActivity activity) async {
    _items = [..._items.where((item) => item.id != activity.id), activity];
    _sortNewestFirst();
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String id) async {
    final before = _items.length;
    _items = _items.where((item) => item.id != id).toList();
    if (_items.length == before) return;
    notifyListeners();
    await _persist();
  }

  void _sortNewestFirst() {
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _persist() async {
    try {
      await _store.write(jsonEncode([for (final a in _items) a.toJson()]));
    } catch (_) {
      return;
    }
  }
}