import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_controller.dart';

List<NotificationItem> seed() => [
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

void main() {
  test('unreadCount awal sama dengan jumlah item', () {
    expect(NotificationController(initial: seed()).unreadCount, 2);
  });

  test('markAsRead mengurangi unreadCount', () {
    final controller = NotificationController(initial: seed());
    controller.markAsRead('a');
    expect(controller.unreadCount, 1);
  });

  test('markAllAsRead mengosongkan unreadCount', () {
    final controller = NotificationController(initial: seed());
    controller.markAllAsRead();
    expect(controller.unreadCount, 0);
  });
}