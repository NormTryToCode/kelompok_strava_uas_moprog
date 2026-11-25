import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/data/dummy_notifications.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() => buildDummyNotifications();

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

  void markAsRead(String id) {
    state = [
      for (final item in state)
        item.id == id ? item.copyWith(isRead: true) : item,
    ];
  }

  void markAllAsRead() {
    state = [for (final item in state) item.copyWith(isRead: true)];
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void restore(NotificationItem item, int index) {
    if (state.any((e) => e.id == item.id)) return;
    final position =
        index < 0 ? 0 : (index > state.length ? state.length : index);
    state = [...state.sublist(0, position), item, ...state.sublist(position)];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationItem>>(
  NotificationsNotifier.new,
);

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((item) => !item.isRead).length;
});