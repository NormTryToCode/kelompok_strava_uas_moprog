import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/data/dummy_notifications.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';

final notificationStoreProvider = Provider<NotificationStore>((ref) {
  return FirestoreNotificationStore();
});

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  NotificationStore get _store => ref.read(notificationStoreProvider);

  @override
  List<NotificationItem> build() => buildDummyNotifications();

  Future<void> load() async {
    try {
      final stored = await _store.read();
      if (stored != null) {
        state = List.unmodifiable(stored);
      }
    } catch (_) {
      return;
    }
  }

  void addNotification({
    required String title,
    required String body,
    NotificationPref? preference,
  }) {
    if (preference != null && !ref.read(settingsProvider).isEnabled(preference)) {
      return;
    }
    final item = NotificationItem(
      id: 'n_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    state = [item, ...state];
    unawaited(_persist(state));
  }

  void notifyActivityLogged({
    required String title,
    required String distanceLabel,
  }) {
    addNotification(
      title: 'Activity logged: $title',
      body: 'Recorded $distanceLabel. Keep your streak going!',
    );
  }

  void notifyFollowing({required String personName}) {
    addNotification(
      title: 'Now following $personName',
      body: 'You will see updates from $personName in your feed.',
      preference: NotificationPref.followers,
    );
  }

  void notifyClubJoined({required String clubName}) {
    addNotification(
      title: 'Joined $clubName',
      body: 'You are now a member of $clubName. Stay tuned for club events!',
      preference: NotificationPref.clubEvents,
    );
  }

  void markAsRead(String id) {
    state = [
      for (final item in state)
        item.id == id ? item.copyWith(isRead: true) : item,
    ];
    unawaited(_persist(state));
  }

  void markAllAsRead() {
    state = [for (final item in state) item.copyWith(isRead: true)];
    unawaited(_persist(state));
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
    unawaited(_persist(state));
  }

  void restore(NotificationItem item, int index) {
    if (state.any((e) => e.id == item.id)) return;
    final position =
        index < 0 ? 0 : (index > state.length ? state.length : index);
    state = [...state.sublist(0, position), item, ...state.sublist(position)];
    unawaited(_persist(state));
  }

  Future<void> _persist(List<NotificationItem> items) async {
    try {
      await _store.write(items);
    } catch (_) {
      return;
    }
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationItem>>(
  NotificationsNotifier.new,
);

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((item) => !item.isRead).length;
});