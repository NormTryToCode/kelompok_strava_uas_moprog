import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';

void main() {
  test('FirestoreNotificationStore membaca dan mem-parsing notifikasi dari Firestore',
      () async {
    final store = FirestoreNotificationStore(
      fallback: MemoryNotificationStore(),
      userId: () => 'uid_1',
      readAll: (_) async => [
        {
          'id': 'uid_1',
          'items': [
            {
              'id': 'n1',
              'title': 'Synced alert',
              'body': 'Loaded from Firestore',
              'createdAt': '2026-11-27T10:00:00.000',
              'isRead': true,
            },
          ],
        },
      ],
      saveDoc: (_, _, _) async {},
    );

    final loaded = await store.read();
    expect(loaded, isNotNull);
    expect(loaded!.single.title, 'Synced alert');
    expect(loaded.single.isRead, isTrue);
  });

  test('notificationsProvider memuat dari store dan menyimpan perubahan status baca',
      () async {
    final store = MemoryNotificationStore([
      NotificationItem(
        id: 'n1',
        title: 'Saved item',
        body: 'Body',
        createdAt: DateTime(2026, 11, 27),
      ),
    ]);
    final container = ProviderContainer(
      overrides: [notificationStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container.read(notificationsProvider.notifier).load();
    expect(container.read(notificationsProvider).single.title, 'Saved item');

    container.read(notificationsProvider.notifier).markAsRead('n1');
    await Future<void>.delayed(Duration.zero);
    expect((await store.read())!.single.isRead, isTrue);
  });
}