import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/suggested_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

ProviderContainer _container() {
  final container = ProviderContainer(
    overrides: [
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  testWidgets('mengetuk Follow menambah notifikasi saat preferensi aktif',
      (tester) async {
    final container = _container();
    final unreadBefore = container.read(unreadCountProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SuggestedTab())),
      ),
    );

    await tester.tap(find.text('Follow').first);
    await tester.pump();

    expect(container.read(unreadCountProvider), unreadBefore + 1);
    expect(
      container.read(notificationsProvider).first.title,
      startsWith('Now following '),
    );
  });

  testWidgets('mengetuk Follow tidak menambah notifikasi saat preferensi mati',
      (tester) async {
    final container = _container();
    await container
        .read(settingsProvider.notifier)
        .setNotification(NotificationPref.followers, false);
    final unreadBefore = container.read(unreadCountProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SuggestedTab())),
      ),
    );

    await tester.tap(find.text('Follow').first);
    await tester.pump();

    expect(container.read(unreadCountProvider), unreadBefore);
  });
}