import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/record/record_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

Widget _wrap() {
  return ProviderScope(
    overrides: [
      activityStoreProvider.overrideWithValue(MemoryActivityStore()),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
    ],
    child: const MaterialApp(home: Record()),
  );
}

void main() {
  testWidgets('menampilkan header Record beserta tombol aksi', (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('Record'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('ikon cari membuka SearchPage', (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('ikon pengaturan membuka SettingsPage', (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('tombol Log Manual Activity membuka ManualActivityPage',
      (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.text('Log Manual Activity'));
    await tester.pumpAndSettle();

    expect(find.byType(ManualActivityPage), findsOneWidget);
  });

  testWidgets('menampilkan kartu Walk, Run, Ride dan tombol More sports',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Walk'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
    expect(find.text('Ride'), findsOneWidget);
    expect(find.text('More sports'), findsOneWidget);
  });

  testWidgets(
      'menampilkan section Strength intro series dan carousel kartu latihan',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump(const Duration(milliseconds: 300));

    final verticalScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    final seriesTitle = find.text('Strength intro series');
    await tester.scrollUntilVisible(
      seriesTitle,
      200,
      scrollable: verticalScrollable,
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(seriesTitle, findsOneWidget);
    expect(
      find.text(
        'Build the foundations of strength training across 4 easy-to-follow workouts, gaining confidence and momentum with every session.',
      ),
      findsOneWidget,
    );
    expect(find.text('Full body'), findsOneWidget);
    expect(find.text('Lower body'), findsOneWidget);
    expect(find.text('Weight Training \u00B7 20m \u00B7 Easy'), findsWidgets);

    final horizontalScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.right,
    );
    await tester.scrollUntilVisible(
      find.text('Core'),
      250,
      scrollable: horizontalScrollable,
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Upper body'), findsOneWidget);
    expect(find.text('Core'), findsOneWidget);
  });

  testWidgets('mengetuk kartu latihan membuka preview bottom sheet',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump(const Duration(milliseconds: 300));

    final verticalScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    final fullBodyCard = find.text('Full body');
    await tester.scrollUntilVisible(
      fullBodyCard,
      250,
      scrollable: verticalScrollable,
    );
    await tester.ensureVisible(fullBodyCard);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(fullBodyCard);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Start Workout'), findsOneWidget);
  });
}
