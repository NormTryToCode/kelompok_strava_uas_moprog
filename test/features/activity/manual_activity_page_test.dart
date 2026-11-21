import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 2000);
  addTearDown(tester.view.reset);
}

ActivityController _controller() {
  return ActivityController(store: MemoryActivityStore());
}

Widget _page(ActivityController controller) {
  return MaterialApp(
    home: ManualActivityPage(
      controller: controller,
      initialDate: DateTime(2026, 11, 10),
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
    await tester.pumpWidget(_page(_controller()));

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
    final controller = _controller();

    await tester.pumpWidget(_page(controller));
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Use minutes or h:mm, e.g. 45 or 1:30'), findsOneWidget);
    expect(find.text('Enter a distance greater than 0'), findsOneWidget);
    expect(controller.count, 0);
  });

  testWidgets('durasi nol ditolak', (tester) async {
    _tallScreen(tester);
    final controller = _controller();

    await tester.pumpWidget(_page(controller));
    await _fill(tester, title: 'Run', duration: '0', distance: '5');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Use minutes or h:mm, e.g. 45 or 1:30'), findsOneWidget);
    expect(controller.count, 0);
  });

  testWidgets('form valid menyimpan aktivitas dengan data yang benar',
      (tester) async {
    _tallScreen(tester);
    final controller = _controller();

    await tester.pumpWidget(_page(controller));
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

    final saved = controller.items.single;

    expect(saved.title, 'Morning ride');
    expect(saved.type, ActivityType.ride);
    expect(saved.duration, const Duration(hours: 1, minutes: 30));
    expect(saved.distanceKm, 25.5);
    expect(saved.date, DateTime(2026, 11, 10));
    expect(find.text('Activity saved'), findsOneWidget);
  });
}