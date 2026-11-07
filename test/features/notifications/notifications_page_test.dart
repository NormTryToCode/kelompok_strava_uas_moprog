import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_controller.dart';

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
}