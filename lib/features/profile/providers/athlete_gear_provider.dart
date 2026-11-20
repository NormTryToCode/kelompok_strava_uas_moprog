import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/athlete_gear.dart';

typedef CustomBrandsMap = Map<String, List<String>>;

final athleteGearProvider =
  NotifierProvider<AthleteGearNotifier, List<AthleteGear>>(
    AthleteGearNotifier.new,
);

final activeGearCountProvider = Provider<int>((ref) {
  final gearList = ref.watch(athleteGearProvider);
  return gearList.where((item) => !item.isRetired).length;
});

final customBrandsProvider =
  NotifierProvider<CustomBrandsNotifier, CustomBrandsMap>(
    CustomBrandsNotifier.new,
);

class AthleteGearNotifier extends Notifier<List<AthleteGear>> {
  static const String _storageKey = 'athlete_gear_list_v1';
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  bool _isDisposed = false;

  @override
  List<AthleteGear> build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });
    _loadFromStorage();
    return const [];
  }

  Future<void> _loadFromStorage() async {
    try {
      final String? rawJson = await _asyncPrefs.getString(_storageKey);
      if (rawJson == null || rawJson.isEmpty || _isDisposed) return;

      final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
      final List<AthleteGear> loaded = decoded
        .map((e) => AthleteGear.fromJson(e as Map<String, dynamic>))
        .toList();

      if (!_isDisposed) {
        state = loaded;
      }
    } catch (_) {
    }
  }

  Future<void> _saveToStorage(List<AthleteGear> items) async {
    final String encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _asyncPrefs.setString(_storageKey, encoded);
  }

  Future<void> addGear(AthleteGear gear) async {
    final updated = [gear, ...state];
    state = updated;
    await _saveToStorage(updated);
  }

  Future<void> updateGear(AthleteGear updatedGear) async {
    final updated = [
      for (final item in state)
        if (item.id == updatedGear.id) updatedGear else item,
    ];
    state = updated;
    await _saveToStorage(updated);
  }

  Future<void> toggleRetireGear(String gearId) async {
    final updated = [
      for (final item in state)
        if (item.id == gearId)
          item.copyWith(isRetired: !item.isRetired)
        else
          item,
    ];
    state = updated;
    await _saveToStorage(updated);
  }

  Future<void> addDistance(String gearId, double deltaKm) async {
    final updated = [
      for (final item in state)
        if (item.id == gearId)
          item.copyWith(
            currentDistanceKm: (item.currentDistanceKm + deltaKm)
              .clamp(0.0, 99999.0),
          )
        else
          item,
    ];
    state = updated;
    await _saveToStorage(updated);
  }

  Future<void> deleteGear(String gearId) async {
    final updated = state.where((item) => item.id != gearId).toList();
    state = updated;
    await _saveToStorage(updated);
  }
}

class CustomBrandsNotifier extends Notifier<CustomBrandsMap> {
  static const String _brandsKey = 'athlete_custom_gear_brands_v1';
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  bool _isDisposed = false;

  @override
  CustomBrandsMap build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });
    _loadBrands();
    return const {};
  }

  Future<void> _loadBrands() async {
    try {
      final String? raw = await _asyncPrefs.getString(_brandsKey);
      if (raw == null || raw.isEmpty || _isDisposed) return;

      final Map<String, dynamic> decoded =
        jsonDecode(raw) as Map<String, dynamic>;
      final CustomBrandsMap parsed = decoded.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e.toString()).toList(),
        ),
      );
      if (!_isDisposed) {
        state = parsed;
      }
    } catch (_) {}
  }

  Future<void> addCustomBrand(GearCategory category, String brandName) async {
    final trimmed = brandName.trim();
    if (trimmed.isEmpty) return;

    final existing = List<String>.from(state[category.name] ?? const []);
    final alreadyExists = existing.any(
      (b) => b.toLowerCase() == trimmed.toLowerCase(),
    );
    if (alreadyExists) return;

    existing.add(trimmed);
    final CustomBrandsMap updated = {
      ...state,
      category.name: existing,
    };
    state = updated;
    await _asyncPrefs.setString(_brandsKey, jsonEncode(updated));
  }
}