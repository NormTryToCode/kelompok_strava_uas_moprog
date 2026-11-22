import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notifications_page.dart';

class _SingleNotifier extends NotificationsNotifier {
  @override
  List<NotificationItem> build() => [
        NotificationItem(
          id: 'a',
          title: 'Alpha',
          body: 'a',
          createdAt: DateTime(2026, 11, 1),
        ),
      ];
}

Widget _app() {
  return ProviderScope(
    overrides: [notificationsProvider.overrideWith(_SingleNotifier.new)],
    child: const MaterialApp(home: NotificationsPage()),
  );
}

void main() {
  testWidgets('menggeser item menghapusnya dan menampilkan Undo',
      (tester) async {
    await tester.pumpWidget(_app());

    await tester.drag(find.text('Alpha'), const Offset(-700, 0));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsNothing);
    expect(find.text('No notifications yet'), findsOneWidget);
    expect(find.text('Notification removed'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
  });

  testWidgets('Undo mengembalikan notifikasi yang dihapus', (tester) async {
    await tester.pumpWidget(_app());

    await tester.drag(find.text('Alpha'), const Offset(-700, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('No notifications yet'), findsNothing);
  });
}