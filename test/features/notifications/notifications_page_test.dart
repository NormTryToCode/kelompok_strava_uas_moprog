import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';

class _SeededNotifier extends NotificationsNotifier {
  @override
  List<NotificationItem> build() => [
        NotificationItem(
          id: 'a',
          title: 'A',
          body: 'a',
          createdAt: DateTime(2026, 11, 1),
        ),
        NotificationItem(
          id: 'b',
          title: 'B',
          body: 'b',
          createdAt: DateTime(2026, 11, 2),
        ),
      ];
}

Widget _app({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [
      notificationStoreProvider.overrideWithValue(MemoryNotificationStore()),
      ...overrides,
    ],
    child: const MaterialApp(home: NotificationsPage()),
  );
}

ProviderContainer _container(WidgetTester tester) {
  return ProviderScope.containerOf(
    tester.element(find.byType(NotificationsPage)),
  );
}

void main() {
  testWidgets('menampilkan tampilan kosong saat belum ada notifikasi',
      (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('No notifications yet'), findsOneWidget);
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('mengetuk item menandainya sudah dibaca', (tester) async {
    await tester.pumpWidget(
      _app(
        overrides: [notificationsProvider.overrideWith(_SeededNotifier.new)],
      ),
    );

    expect(_container(tester).read(unreadCountProvider), 2);

    await tester.tap(find.text('A'));
    await tester.pump();

    expect(_container(tester).read(unreadCountProvider), 1);
    expect(find.text('Mark all read'), findsOneWidget);
  });

  testWidgets('Mark all read menandai semuanya dan tombol hilang',
      (tester) async {
    await tester.pumpWidget(
      _app(
        overrides: [notificationsProvider.overrideWith(_SeededNotifier.new)],
      ),
    );

    await tester.tap(find.text('Mark all read'));
    await tester.pump();

    expect(_container(tester).read(unreadCountProvider), 0);
    expect(find.text('Mark all read'), findsNothing);
  });
}