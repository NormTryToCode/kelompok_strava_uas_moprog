import 'package:flutter/foundation.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/data/dummy_notifications.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';

class NotificationController extends ChangeNotifier {
  NotificationController({List<NotificationItem>? initial})
      : _items = initial ?? buildDummyNotifications();

  static final NotificationController instance = NotificationController();

  List<NotificationItem> _items;

  List<NotificationItem> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((e) => !e.isRead).length;

  void markAsRead(String id) {
    _items = [
      for (final e in _items) e.id == id ? e.copyWith(isRead: true) : e,
    ];
    notifyListeners();
  }

  void markAllAsRead() {
    _items = [for (final e in _items) e.copyWith(isRead: true)];
    notifyListeners();
  }
}