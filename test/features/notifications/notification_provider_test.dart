import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';

ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('awal: semua notifikasi dummy belum dibaca', () {
    final container = _container();
    final total = container.read(notificationsProvider).length;

    expect(total, greaterThan(0));
    expect(container.read(unreadCountProvider), total);
  });

  test('markAsRead hanya menandai satu notifikasi', () {
    final container = _container();
    final total = container.read(notificationsProvider).length;
    final id = container.read(notificationsProvider).first.id;

    container.read(notificationsProvider.notifier).markAsRead(id);

    final updated = container.read(notificationsProvider);
    expect(updated.firstWhere((e) => e.id == id).isRead, isTrue);
    expect(container.read(unreadCountProvider), total - 1);
  });

  test('markAsRead dengan id tidak dikenal tidak mengubah apa pun', () {
    final container = _container();
    final before = container.read(unreadCountProvider);

    container.read(notificationsProvider.notifier).markAsRead('tidak-ada');

    expect(container.read(unreadCountProvider), before);
  });

  test('markAllAsRead mengosongkan jumlah belum dibaca', () {
    final container = _container();

    container.read(notificationsProvider.notifier).markAllAsRead();

    expect(container.read(unreadCountProvider), 0);
  });

  test('unreadCountProvider memberi tahu listener saat berubah', () async {
    final container = _container();
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

  test('remove menghapus satu notifikasi', () {
    final container = _container();
    final notifier = container.read(notificationsProvider.notifier);
    final before = container.read(notificationsProvider).length;
    final id = container.read(notificationsProvider).first.id;

    notifier.remove(id);

    final after = container.read(notificationsProvider);
    expect(after.length, before - 1);
    expect(after.any((e) => e.id == id), isFalse);
  });

  test('restore mengembalikan notifikasi ke posisi semula', () {
    final container = _container();
    final notifier = container.read(notificationsProvider.notifier);
    final ids = container.read(notificationsProvider).map((e) => e.id).toList();
    final removed = container.read(notificationsProvider)[1];

    notifier.remove(removed.id);
    notifier.restore(removed, 1);

    expect(container.read(notificationsProvider).map((e) => e.id).toList(), ids);
  });

  test('restore dengan indeks di luar batas menaruhnya di ujung', () {
    final container = _container();
    final notifier = container.read(notificationsProvider.notifier);
    final removed = container.read(notificationsProvider).first;

    notifier.remove(removed.id);
    notifier.restore(removed, 99);

    expect(container.read(notificationsProvider).last.id, removed.id);
  });

  test('restore tidak menambah notifikasi yang sudah ada', () {
    final container = _container();
    final notifier = container.read(notificationsProvider.notifier);
    final existing = container.read(notificationsProvider).first;
    final before = container.read(notificationsProvider).length;

    notifier.restore(existing, 0);

    expect(container.read(notificationsProvider).length, before);
  });
}