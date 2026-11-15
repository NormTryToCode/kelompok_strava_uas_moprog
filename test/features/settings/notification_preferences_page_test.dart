import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/notification_preferences_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

Widget _page(SettingsController controller) {
  return MaterialApp(
    home: NotificationPreferencesPage(controller: controller),
  );
}

void main() {
  testWidgets('menampilkan semua preferensi dengan saklar', (tester) async {
    final controller = SettingsController(store: MemorySettingsStore());

    await tester.pumpWidget(_page(controller));

    expect(find.text('PUSH NOTIFICATIONS'), findsOneWidget);
    for (final pref in NotificationPref.values) {
      expect(find.text(pref.label), findsOneWidget);
    }
    expect(find.byType(Switch), findsNWidgets(NotificationPref.values.length));
  });

  testWidgets('mengetuk baris mengubah dan menyimpan preferensi',
      (tester) async {
    final store = MemorySettingsStore();
    final controller = SettingsController(store: store);

    await tester.pumpWidget(_page(controller));

    await tester.tap(find.text('New followers'));
    await tester.pump();

    expect(controller.isEnabled(NotificationPref.followers), isFalse);
    expect(controller.enabledCount, 2);
    expect(
      await store.readBool(NotificationPref.followers.storageKey),
      isFalse,
    );
  });
}