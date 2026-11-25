import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';

List<NotificationItem> buildDummyNotifications() {
  final now = DateTime.now();
  return [
    NotificationItem(
      id: 'n1',
      title: 'Connecting a device to Stride',
      body:
          'Want to track all your effort? Connecting a device to Stride lets you sync stats like heart rate, power, and more.',
      createdAt: now.subtract(const Duration(days: 11)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'Join the November cycling challenge',
      body: 'Ride 200 km this month and earn a badge.',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    NotificationItem(
      id: 'n3',
      title: 'Welcome to Stride',
      body: 'Record your first activity to start your weekly streak.',
      createdAt: now.subtract(const Duration(hours: 5)),
    ),
  ];
}