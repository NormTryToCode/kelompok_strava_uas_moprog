import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

List<NotificationItem> _fixtures() => [
      NotificationItem(
        id: 'n1',
        title: 'First alert',
        body: 'Body 1',
        createdAt: DateTime(2026, 11, 20),
      ),
      NotificationItem(
        id: 'n2',
        title: 'Second alert',
        body: 'Body 2',
        createdAt: DateTime(2026, 11, 21),
      ),
      NotificationItem(
        id: 'n3',
        title: 'Third alert',
        body: 'Body 3',
        createdAt: DateTime(2026, 11, 22),
      ),
    ];

ProviderContainer _container({List<NotificationItem>? initial}) {
  final container = ProviderContainer(
    overrides: [
      notificationStoreProvider.overrideWithValue(
        MemoryNotificationStore(initial),
      ),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('awal: daftar notifikasi kosong sebelum dimuat dari Firestore', () {
    final container = _container();

    expect(container.read(notificationsProvider), isEmpty);
    expect(container.read(unreadCountProvider), 0);
  });

  test('markAsRead hanya menandai satu notifikasi', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final total = container.read(notificationsProvider).length;
    final id = container.read(notificationsProvider).first.id;

    container.read(notificationsProvider.notifier).markAsRead(id);

    final updated = container.read(notificationsProvider);
    expect(updated.firstWhere((e) => e.id == id).isRead, isTrue);
    expect(container.read(unreadCountProvider), total - 1);
  });

  test('markAsRead dengan id tidak dikenal tidak mengubah apa pun', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();
    final before = container.read(unreadCountProvider);

    container.read(notificationsProvider.notifier).markAsRead('tidak-ada');

    expect(container.read(unreadCountProvider), before);
  });

  test('markAllAsRead mengosongkan jumlah belum dibaca', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    container.read(notificationsProvider.notifier).markAllAsRead();

    expect(container.read(unreadCountProvider), 0);
  });

  test('unreadCountProvider memberi tahu listener saat berubah', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final initial = container.read(unreadCountProvider);
    final values = <int>[];
    container.listen<int>(
      unreadCountProvider,
      (_, next) => values.add(next),
      fireImmediately: true,
    );

    container.read(notificationsProvider.notifier).markAllAsRead();
    await container.pump();

    expect(values, [initial, 0]);
  });

  test('remove menghapus satu notifikasi', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final notifier = container.read(notificationsProvider.notifier);
    final before = container.read(notificationsProvider).length;
    final id = container.read(notificationsProvider).first.id;

    notifier.remove(id);

    final after = container.read(notificationsProvider);
    expect(after.length, before - 1);
    expect(after.any((e) => e.id == id), isFalse);
  });

  test('restore mengembalikan notifikasi ke posisi semula', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final notifier = container.read(notificationsProvider.notifier);
    final ids = container.read(notificationsProvider).map((e) => e.id).toList();
    final removed = container.read(notificationsProvider)[1];

    notifier.remove(removed.id);
    notifier.restore(removed, 1);

    expect(container.read(notificationsProvider).map((e) => e.id).toList(), ids);
  });

  test('restore dengan indeks di luar batas menaruhnya di ujung', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final notifier = container.read(notificationsProvider.notifier);
    final removed = container.read(notificationsProvider).first;

    notifier.remove(removed.id);
    notifier.restore(removed, 99);

    expect(container.read(notificationsProvider).last.id, removed.id);
  });

  test('restore tidak menambah notifikasi yang sudah ada', () async {
    final container = _container(initial: _fixtures());
    await container.read(notificationsProvider.notifier).load();

    final notifier = container.read(notificationsProvider.notifier);
    final existing = container.read(notificationsProvider).first;
    final before = container.read(notificationsProvider).length;

    notifier.restore(existing, 0);

    expect(container.read(notificationsProvider).length, before);
  });

  test('notifyActivityLogged menambahkan notifikasi belum dibaca di paling atas', () {
    final container = _container();

    container.read(notificationsProvider.notifier).notifyActivityLogged(
          title: 'Morning Run',
          distanceLabel: '5 km',
        );

    expect(container.read(unreadCountProvider), 1);
    expect(
      container.read(notificationsProvider).first.title,
      'Activity logged: Morning Run',
    );
  });

  test('notifyFollowing menambah notifikasi saat preferensi followers aktif', () {
    final container = _container();

    container
        .read(notificationsProvider.notifier)
        .notifyFollowing(personName: 'Dewi Anggraini');

    expect(container.read(unreadCountProvider), 1);
  });

  test('notifyFollowing dilewati saat preferensi followers dimatikan', () async {
    final container = _container();

    await container
        .read(settingsProvider.notifier)
        .setNotification(NotificationPref.followers, false);

    container
        .read(notificationsProvider.notifier)
        .notifyFollowing(personName: 'Dewi Anggraini');

    expect(container.read(unreadCountProvider), 0);
  });
}