import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 2000);
  addTearDown(tester.view.reset);
}

ProviderContainer _container() {
  final container = ProviderContainer(
    overrides: [
      activityStoreProvider.overrideWithValue(MemoryActivityStore()),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore())
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Widget _page(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: ManualActivityPage(
        initialDate: DateTime(2026, 11, 10),
      ),
    ),
  );
}

Future<void> _fill(
  WidgetTester tester, {
  String title = '',
  String duration = '',
  String distance = '',
}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), title);
  await tester.enterText(fields.at(1), duration);
  await tester.enterText(fields.at(2), distance);
}

void main() {
  testWidgets('menampilkan judul, kolom, jenis aktivitas, dan tanggal',
      (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page(_container()));

    expect(find.text('Manual Activity'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Distance (km)'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
    expect(find.text('Ride'), findsOneWidget);
    expect(find.text('10 Nov 2026'), findsOneWidget);
  });

  testWidgets('menyimpan dengan form kosong menampilkan pesan error',
      (tester) async {
    _tallScreen(tester);
    final container = _container();

    await tester.pumpWidget(_page(container));
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Use minutes or h:mm, e.g. 45 or 1:30'), findsOneWidget);
    expect(find.text('Enter a distance greater than 0'), findsOneWidget);
    expect(container.read(activityProvider).count, 0);
  });

  testWidgets('durasi nol ditolak', (tester) async {
    _tallScreen(tester);
    final container = _container();

    await tester.pumpWidget(_page(container));
    await _fill(tester, title: 'Run', duration: '0', distance: '5');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Use minutes or h:mm, e.g. 45 or 1:30'), findsOneWidget);
    expect(container.read(activityProvider).count, 0);
  });

  testWidgets('form valid menyimpan aktivitas dengan data yang benar',
      (tester) async {
    _tallScreen(tester);
    final container = _container();

    await tester.pumpWidget(_page(container));
    await _fill(
      tester,
      title: 'Morning ride',
      duration: '1:30',
      distance: '25,5',
    );
    await tester.tap(find.text('Ride'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = container.read(activityProvider).items.single;

    expect(saved.title, 'Morning ride');
    expect(saved.type, ActivityType.ride);
    expect(saved.duration, const Duration(hours: 1, minutes: 30));
    expect(saved.distanceKm, 25.5);
    expect(saved.date, DateTime(2026, 11, 10));
    expect(find.text('Activity saved'), findsOneWidget);
  });
  testWidgets('menyimpan aktivitas valid juga menambah notifikasi belum dibaca',
      (tester) async {
    _tallScreen(tester);
    final container = _container();
    final unreadBefore = container.read(unreadCountProvider);

    await tester.pumpWidget(_page(container));
    await _fill(
      tester,
      title: 'Evening Run',
      duration: '30',
      distance: '5',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(container.read(unreadCountProvider), unreadBefore + 1);
    expect(
      container.read(notificationsProvider).first.title,
      'Activity logged: Evening Run',
    );
  });
}