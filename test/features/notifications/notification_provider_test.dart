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

  test('unreadCountProvider memberi tahu listener saat berubah', () {
    final container = _container();
    final values = <int>[];
    container.listen<int>(unreadCountProvider, (_, next) => values.add(next));

    container.read(notificationsProvider.notifier).markAllAsRead();

    expect(values, [0]);
  });
}