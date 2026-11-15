import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

enum DistanceUnit {
  kilometers('Kilometers', 'km'),
  miles('Miles', 'mi');

  final String label;
  final String abbreviation;

  const DistanceUnit(this.label, this.abbreviation);
}

enum NotificationPref {
  followers('New followers', 'notify_followers'),
  challenges('Challenge updates', 'notify_challenges'),
  clubEvents('Club events', 'notify_club_events');

  final String label;
  final String storageKey;

  const NotificationPref(this.label, this.storageKey);
}

class SettingsController extends ChangeNotifier {
  SettingsController({SettingsStore? store})
      : _store = store ?? PrefsSettingsStore();

  static final SettingsController instance = SettingsController();

  static const String unitKey = 'distance_unit';

  final SettingsStore _store;
  DistanceUnit _unit = DistanceUnit.kilometers;
  final Map<NotificationPref, bool> _notifications = {
    for (final pref in NotificationPref.values) pref: true,
  };
  bool _loaded = false;

  DistanceUnit get unit => _unit;

  bool get isLoaded => _loaded;

  bool isEnabled(NotificationPref pref) => _notifications[pref] ?? true;

  int get enabledCount => NotificationPref.values.where(isEnabled).length;

  Future<void> load() async {
    try {
      final storedUnit = await _store.readString(unitKey);
      _unit = DistanceUnit.values.firstWhere(
        (unit) => unit.name == storedUnit,
        orElse: () => DistanceUnit.kilometers,
      );
      for (final pref in NotificationPref.values) {
        _notifications[pref] = await _store.readBool(pref.storageKey) ?? true;
      }
    } catch (_) {
      _unit = DistanceUnit.kilometers;
      for (final pref in NotificationPref.values) {
        _notifications[pref] = true;
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setUnit(DistanceUnit value) async {
    if (value == _unit) return;
    _unit = value;
    notifyListeners();
    try {
      await _store.writeString(unitKey, value.name);
    } catch (_) {
      return;
    }
  }

  Future<void> setNotification(NotificationPref pref, bool enabled) async {
    if (isEnabled(pref) == enabled) return;
    _notifications[pref] = enabled;
    notifyListeners();
    try {
      await _store.writeBool(pref.storageKey, enabled);
    } catch (_) {
      return;
    }
  }
}