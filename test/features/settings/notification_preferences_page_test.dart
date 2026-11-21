import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/notification_preferences_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

ProviderContainer _container(SettingsStore store) {
  final container = ProviderContainer(
    overrides: [settingsStoreProvider.overrideWithValue(store)],
  );
  addTearDown(container.dispose);
  return container;
}

Widget _page(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: NotificationPreferencesPage()),
  );
}

void main() {
  testWidgets('menampilkan semua preferensi dengan saklar', (tester) async {
    final container = _container(MemorySettingsStore());

    await tester.pumpWidget(_page(container));

    expect(find.text('PUSH NOTIFICATIONS'), findsOneWidget);
    for (final pref in NotificationPref.values) {
      expect(find.text(pref.label), findsOneWidget);
    }
    expect(find.byType(Switch), findsNWidgets(NotificationPref.values.length));
  });

  testWidgets('mengetuk baris mengubah dan menyimpan preferensi',
      (tester) async {
    final store = MemorySettingsStore();
    final container = _container(store);

    await tester.pumpWidget(_page(container));

    await tester.tap(find.text('New followers'));
    await tester.pump();

    final state = container.read(settingsProvider);
    expect(state.isEnabled(NotificationPref.followers), isFalse);
    expect(state.enabledCount, 2);
    expect(
      await store.readBool(NotificationPref.followers.storageKey),
      isFalse,
    );
  });
}