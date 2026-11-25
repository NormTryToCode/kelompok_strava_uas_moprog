import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

ProviderContainer _container({
  ActivityStore? activityStore,
  SettingsStore? settingsStore,
}) {
  final container = ProviderContainer(
    overrides: [
      activityStoreProvider.overrideWithValue(
        activityStore ?? MemoryActivityStore(),
      ),
      settingsStoreProvider.overrideWithValue(
        settingsStore ?? MemorySettingsStore(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Widget _wrap(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: ActivityListPage()),
  );
}

void main() {
  testWidgets('menampilkan keadaan kosong saat belum ada aktivitas',
      (tester) async {
    final container = _container();

    await tester.pumpWidget(_wrap(container));
    await tester.pumpAndSettle();

    expect(find.text('No activities yet'), findsOneWidget);
    expect(find.text('Log Activity'), findsOneWidget);
  });

  testWidgets('menampilkan daftar aktivitas dan ringkasan jarak dalam km',
      (tester) async {
    final container = _container();
    await container.read(activityProvider.notifier).add(
          ManualActivity(
            id: 'a1',
            title: 'Morning Run',
            type: ActivityType.run,
            date: DateTime(2026, 11, 20),
            duration: const Duration(minutes: 30),
            distanceKm: 5,
            notes: 'Easy pace',
          ),
        );

    await tester.pumpWidget(_wrap(container));
    await tester.pumpAndSettle();

    expect(find.text('Morning Run'), findsOneWidget);
    expect(find.text('Easy pace'), findsOneWidget);
    expect(find.text('5 km'), findsNWidgets(2));
  });

  testWidgets('menyesuaikan satuan jarak ke miles dari settingsProvider',
      (tester) async {
    final settingsStore = MemorySettingsStore();
    await settingsStore.writeString(SettingsNotifier.unitKey, 'miles');
    final container = _container(settingsStore: settingsStore);

    await container.read(activityProvider.notifier).add(
          ManualActivity(
            id: 'a1',
            title: 'Evening Ride',
            type: ActivityType.ride,
            date: DateTime(2026, 11, 20),
            duration: const Duration(hours: 1),
            distanceKm: 10,
          ),
        );

    await tester.pumpWidget(_wrap(container));
    await tester.pumpAndSettle();

    expect(find.text('6.21 mi'), findsNWidgets(2));
  });

  testWidgets('mengetuk ikon hapus menghapus aktivitas dari daftar',
      (tester) async {
    final container = _container();
    await container.read(activityProvider.notifier).add(
          ManualActivity(
            id: 'a1',
            title: 'Tempo Run',
            type: ActivityType.run,
            date: DateTime(2026, 11, 20),
            duration: const Duration(minutes: 25),
            distanceKm: 5,
          ),
        );

    await tester.pumpWidget(_wrap(container));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete Tempo Run'));
    await tester.pumpAndSettle();

    expect(container.read(activityProvider).count, 0);
    expect(find.text('No activities yet'), findsOneWidget);
  });
}