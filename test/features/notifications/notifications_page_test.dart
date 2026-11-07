import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';

void main() {
  testWidgets('menampilkan daftar notifikasi', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotificationsPage()));

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Next step: connect a device'), findsOneWidget);
  });

  testWidgets('menampilkan tampilan kosong', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsPage(controller: NotificationController(initial: [])),
      ),
    );

    expect(find.text('No notifications yet'), findsOneWidget);
  });

  testWidgets('mengetuk item menandainya sudah dibaca', (tester) async {
    final controller = NotificationController(
      initial: [
        NotificationItem(
          id: 'a',
          title: 'A',
          body: 'a',
          createdAt: DateTime(2026, 11, 1),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(home: NotificationsPage(controller: controller)),
    );

    expect(find.text('Mark all read'), findsOneWidget);

    await tester.tap(find.text('A'));
    await tester.pump();

    expect(controller.unreadCount, 0);
    expect(find.text('Mark all read'), findsNothing);
  });
}