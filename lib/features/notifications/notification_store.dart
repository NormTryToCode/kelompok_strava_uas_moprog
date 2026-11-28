import 'dart:convert';

import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef NotificationJsonMap = Map<String, dynamic>;
typedef NotificationReadAll = Future<List<NotificationJsonMap>> Function(
  String collection,
);
typedef NotificationSaveDoc = Future<void> Function(
  String collection,
  String id,
  NotificationJsonMap data,
);

abstract class NotificationStore {
  Future<List<NotificationItem>?> read();

  Future<void> write(List<NotificationItem> items);
}

class PrefsNotificationStore implements NotificationStore {
  static const String _keyPrefix = 'user_notifications_json';

  final String Function() _userId;
  SharedPreferencesAsync? _cache;

  PrefsNotificationStore({String Function()? userId})
      : _userId = userId ?? resolveStorageUserId;

  SharedPreferencesAsync get _prefs => _cache ??= SharedPreferencesAsync();

  String get _scopedKey => '${_keyPrefix}_${_userId()}';

  @override
  Future<List<NotificationItem>?> read() async {
    final raw = await _prefs.getString(_scopedKey);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return [
      for (final entry in decoded)
        NotificationItem.fromJson(entry as NotificationJsonMap),
    ];
  }

  @override
  Future<void> write(List<NotificationItem> items) {
    final encoded = jsonEncode([for (final item in items) item.toJson()]);
    return _prefs.setString(_scopedKey, encoded);
  }
}

class FirestoreNotificationStore implements NotificationStore {
  static const String collectionName = 'user_notifications';

  final NotificationStore _fallback;
  final NotificationReadAll? _readAll;
  final NotificationSaveDoc? _saveDoc;
  final String Function() _userId;

  FirestoreNotificationStore({
    NotificationStore? fallback,
    NotificationReadAll? readAll,
    NotificationSaveDoc? saveDoc,
    String Function()? userId,
  })  : _userId = userId ?? resolveStorageUserId,
        _fallback = fallback ?? PrefsNotificationStore(userId: userId),
        _readAll = readAll,
        _saveDoc = saveDoc;

  @override
  Future<List<NotificationItem>?> read() async {
    final docId = _userId();
    try {
      final reader = _readAll ?? DatabaseService.instance.getAll;
      final docs = await reader(collectionName);
      for (final doc in docs) {
        if (doc['id'] == docId && doc['items'] is List) {
          return [
            for (final entry in doc['items'] as List)
              if (entry is Map)
                NotificationItem.fromJson(
                  NotificationJsonMap.from(entry),
                ),
          ];
        }
      }
      return const <NotificationItem>[];
    } catch (_) {
      try {
        return await _fallback.read();
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<void> write(List<NotificationItem> items) async {
    try {
      await _fallback.write(items);
    } catch (_) {}
    try {
      final writer = _saveDoc ?? DatabaseService.instance.save;
      await writer(collectionName, _userId(), {
        'items': [for (final item in items) item.toJson()],
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return;
    }
  }
}

class MemoryNotificationStore implements NotificationStore {
  List<NotificationItem>? _items;

  MemoryNotificationStore([List<NotificationItem>? initial])
      : _items = initial == null ? null : List<NotificationItem>.from(initial);

  @override
  Future<List<NotificationItem>?> read() async {
    return _items == null ? null : List<NotificationItem>.from(_items!);
  }

  @override
  Future<void> write(List<NotificationItem> items) async {
    _items = List<NotificationItem>.from(items);
  }
}