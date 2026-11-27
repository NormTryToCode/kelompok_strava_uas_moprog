import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

enum SettingsDistanceUnit {
  kilometers('Kilometers', 'km'),
  miles('Miles', 'mi');

  final String label;
  final String abbreviation;

  const SettingsDistanceUnit(this.label, this.abbreviation);
}

enum PrivacyLevel {
  everyone('Everyone'),
  followersOnly('Followers only'),
  onlyYou('Only you');

  final String label;

  const PrivacyLevel(this.label);
}

enum NotificationPref {
  followers('New followers', 'notify_followers'),
  challenges('Challenge updates', 'notify_challenges'),
  clubEvents('Club events', 'notify_club_events');

  final String label;
  final String storageKey;

  const NotificationPref(this.label, this.storageKey);
}

class SettingsState {
  final SettingsDistanceUnit unit;
  final PrivacyLevel privacy;
  final Map<NotificationPref, bool> notifications;
  final bool isLoaded;

  const SettingsState({
    this.unit = SettingsDistanceUnit.kilometers,
    this.privacy = PrivacyLevel.everyone,
    this.notifications = const {
      NotificationPref.followers: true,
      NotificationPref.challenges: true,
      NotificationPref.clubEvents: true,
    },
    this.isLoaded = false,
  });

  bool isEnabled(NotificationPref pref) => notifications[pref] ?? true;

  int get enabledCount => NotificationPref.values.where(isEnabled).length;

  SettingsState copyWith({
    SettingsDistanceUnit? unit,
    PrivacyLevel? privacy,
    Map<NotificationPref, bool>? notifications,
    bool? isLoaded,
  }) {
    return SettingsState(
      unit: unit ?? this.unit,
      privacy: privacy ?? this.privacy,
      notifications: notifications ?? this.notifications,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

final settingsStoreProvider = Provider<SettingsStore>((ref) {
  return FirestoreSettingsStore();
});

class SettingsNotifier extends Notifier<SettingsState> {
  static const String unitKey = 'distance_unit';
  static const String privacyKey = 'privacy_level';

  SettingsStore get _store => ref.read(settingsStoreProvider);

  @override
  SettingsState build() => const SettingsState();

  Future<void> load() async {
    var unit = SettingsDistanceUnit.kilometers;
    var privacy = PrivacyLevel.everyone;
    final notifications = <NotificationPref, bool>{
      for (final pref in NotificationPref.values) pref: true,
    };
    try {
      final storedUnit = await _store.readString(unitKey);
      unit = SettingsDistanceUnit.values.firstWhere(
        (candidate) => candidate.name == storedUnit,
        orElse: () => SettingsDistanceUnit.kilometers,
      );
      final storedPrivacy = await _store.readString(privacyKey);
      privacy = PrivacyLevel.values.firstWhere(
        (candidate) => candidate.name == storedPrivacy,
        orElse: () => PrivacyLevel.everyone,
      );
      for (final pref in NotificationPref.values) {
        notifications[pref] = await _store.readBool(pref.storageKey) ?? true;
      }
    } catch (_) {
      unit = SettingsDistanceUnit.kilometers;
      privacy = PrivacyLevel.everyone;
      for (final pref in NotificationPref.values) {
        notifications[pref] = true;
      }
    }
    state = SettingsState(
      unit: unit,
      privacy: privacy,
      notifications: Map.unmodifiable(notifications),
      isLoaded: true,
    );
  }

  Future<void> setUnit(SettingsDistanceUnit value) async {
    if (value == state.unit) return;
    state = state.copyWith(unit: value);
    try {
      await _store.writeString(unitKey, value.name);
    } catch (_) {
      return;
    }
  }

  Future<void> setPrivacy(PrivacyLevel value) async {
    if (value == state.privacy) return;
    state = state.copyWith(privacy: value);
    try {
      await _store.writeString(privacyKey, value.name);
    } catch (_) {
      return;
    }
  }

  Future<void> setNotification(NotificationPref pref, bool enabled) async {
    if (state.isEnabled(pref) == enabled) return;
    final updated = Map<NotificationPref, bool>.from(state.notifications)
      ..[pref] = enabled;
    state = state.copyWith(notifications: Map.unmodifiable(updated));
    try {
      await _store.writeBool(pref.storageKey, enabled);
    } catch (_) {
      return;
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);