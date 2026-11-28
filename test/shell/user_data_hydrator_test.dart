import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/models/notification_item.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_store.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_store.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_store.dart';
import 'package:kelompok_strava_uas_moprog/shell/user_data_hydrator.dart';

void main() {
  test('hydrate memuat kelima provider dari store masing-masing', () async {
    final settingsStore = MemorySettingsStore();
    await settingsStore.writeString(SettingsNotifier.unitKey, 'miles');
    await settingsStore.writeString(
      SettingsNotifier.privacyKey,
      PrivacyLevel.followersOnly.name,
    );

    final sampleActivity = ManualActivity(
      id: 'a1',
      title: 'Morning Run',
      type: ActivityType.run,
      date: DateTime(2026, 11, 27),
      duration: const Duration(minutes: 30),
      distanceKm: 5,
    );

    final container = ProviderContainer(
      overrides: [
        followStoreProvider.overrideWithValue(MemoryFollowStore({'p1', 'p2'})),
        searchHistoryStoreProvider
            .overrideWithValue(MemorySearchHistoryStore(['trail', 'bandung'])),
        notificationStoreProvider.overrideWithValue(
          MemoryNotificationStore([
            NotificationItem(
              id: 'n1',
              title: 'Synced',
              body: 'Loaded',
              createdAt: DateTime(2026, 11, 27),
              isRead: true,
            ),
          ]),
        ),
        settingsStoreProvider.overrideWithValue(settingsStore),
        activityStoreProvider.overrideWithValue(
          MemoryActivityStore(jsonEncode([sampleActivity.toJson()])),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(userDataHydratorProvider)();

    expect(container.read(followProvider), {'p1', 'p2'});
    expect(container.read(searchHistoryProvider), ['trail', 'bandung']);
    expect(container.read(notificationsProvider).single.title, 'Synced');
    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.miles);
    expect(
      container.read(settingsProvider).privacy,
      PrivacyLevel.followersOnly,
    );
    expect(container.read(activityProvider).items.single.title, 'Morning Run');
  });
}