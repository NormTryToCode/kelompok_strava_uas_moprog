import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
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
  static const String _collection = 'athlete_gears';
  static const String _storageKey = 'athlete_gear_list_v1';

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  StreamSubscription<List>? _firestoreSub;
  bool _isDisposed = false;

  @override
  List<AthleteGear> build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _firestoreSub?.cancel();
    });

    _loadFromStorage();
    _listenFirestore();
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

      if (!_isDisposed && state.isEmpty) {
        state = loaded;
      }
    } catch (_) {}
  }

  void _listenFirestore() {
    try {
      _firestoreSub = DatabaseService.instance.watch(_collection).listen(
        (docs) {
          if (_isDisposed) return;
          final List<AthleteGear> remoteItems =
            docs.map((doc) => AthleteGear.fromJson(doc)).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          state = remoteItems;
          _saveToLocalCache(remoteItems);
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _saveToLocalCache(List<AthleteGear> items) async {
    final String encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _asyncPrefs.setString(_storageKey, encoded);
  }

  Future<void> addGear(AthleteGear gear) async {
    final updated = [gear, ...state];
    state = updated;
    await _saveToLocalCache(updated);

    try {
      await DatabaseService.instance.save(_collection, gear.id, gear.toJson());
    } catch (_) {}
  }

  Future<void> updateGear(AthleteGear updatedGear) async {
    final updated = [
      for (final item in state)
        if (item.id == updatedGear.id) updatedGear else item,
    ];
    state = updated;
    await _saveToLocalCache(updated);

    try {
      await DatabaseService.instance.save(
        _collection,
        updatedGear.id,
        updatedGear.toJson(),
      );
    } catch (_) {}
  }

  Future<void> toggleRetireGear(String gearId) async {
    AthleteGear? target;
    final updated = [
      for (final item in state)
        if (item.id == gearId)
          target = item.copyWith(isRetired: !item.isRetired)
        else
          item,
    ];
    state = updated;
    await _saveToLocalCache(updated);

    if (target != null) {
      try {
        await DatabaseService.instance.save(
          _collection,
          target.id,
          target.toJson(),
        );
      } catch (_) {}
    }
  }

  Future<void> addDistance(String gearId, double deltaKm) async {
    AthleteGear? target;
    final updated = [
      for (final item in state)
        if (item.id == gearId)
          target = item.copyWith(
            currentDistanceKm:
              (item.currentDistanceKm + deltaKm).clamp(0.0, 99999.0),
          )
        else
          item,
    ];
    state = updated;
    await _saveToLocalCache(updated);

    if (target != null) {
      try {
        await DatabaseService.instance.save(
          _collection,
          target.id,
          target.toJson(),
        );
      } catch (_) {}
    }
  }

  Future<void> deleteGear(String gearId) async {
    final updated = state.where((item) => item.id != gearId).toList();
    state = updated;
    await _saveToLocalCache(updated);

    try {
      await DatabaseService.instance.remove(_collection, gearId);
    } catch (_) {}
  }
}

class CustomBrandsNotifier extends Notifier<CustomBrandsMap> {
  static const String _collection = 'athlete_gear_brands';
  static const String _brandsKey = 'athlete_custom_gear_brands_v1';

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  StreamSubscription<List>? _firestoreSub;
  bool _isDisposed = false;

  @override
  CustomBrandsMap build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _firestoreSub?.cancel();
    });

    _loadLocalBrands();
    _listenFirestore();
    return const {};
  }

  Future<void> _loadLocalBrands() async {
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
      if (!_isDisposed && state.isEmpty) {
        state = parsed;
      }
    } catch (_) {}
  }

  void _listenFirestore() {
    try {
      _firestoreSub = DatabaseService.instance.watch(_collection).listen(
        (docs) {
          if (_isDisposed) return;
          final CustomBrandsMap remoteMap = {};
          for (final doc in docs) {
            final String categoryId = doc['id'] as String? ?? '';
            final List<dynamic> rawBrands =
              doc['brands'] as List<dynamic>? ?? const [];
            if (categoryId.isNotEmpty) {
              remoteMap[categoryId] =
                rawBrands.map((e) => e.toString()).toList();
            }
          }
          state = remoteMap;
          _asyncPrefs.setString(_brandsKey, jsonEncode(remoteMap));
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  Future<void> _syncCategoryBrands(
    GearCategory category,
    List<String> brands,
  ) async {
    final CustomBrandsMap updated = {
      ...state,
      category.name: brands,
    };
    state = updated;
    await _asyncPrefs.setString(_brandsKey, jsonEncode(updated));

    try {
      await DatabaseService.instance.save(
        _collection,
        category.name,
        {'brands': brands},
      );
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
    await _syncCategoryBrands(category, existing);
  }

  Future<void> updateCustomBrand(
    GearCategory category,
    String oldName,
    String newName,
  ) async {
    final trimmedNew = newName.trim();
    if (trimmedNew.isEmpty) return;

    final existing = List<String>.from(state[category.name] ?? const []);
    final int index = existing.indexWhere(
      (b) => b.toLowerCase() == oldName.toLowerCase(),
    );
    if (index == -1) return;

    final bool duplicateInCustom = existing.any(
      (b) =>
        b.toLowerCase() != oldName.toLowerCase() &&
        b.toLowerCase() == trimmedNew.toLowerCase(),
    );
    final bool duplicateInPreset = category.presetBrands.any(
      (b) => b.toLowerCase() == trimmedNew.toLowerCase(),
    );

    if (duplicateInCustom || duplicateInPreset) {
      existing.removeAt(index);
    } else {
      existing[index] = trimmedNew;
    }

    await _syncCategoryBrands(category, existing);
  }

  Future<void> removeCustomBrand(
    GearCategory category,
    String brandName,
  ) async {
    final existing = List<String>.from(state[category.name] ?? const []);
    existing.removeWhere((b) => b.toLowerCase() == brandName.toLowerCase());
    await _syncCategoryBrands(category, existing);
  }
}