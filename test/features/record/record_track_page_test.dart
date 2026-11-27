import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/record/record_page.dart';
import 'package:kelompok_strava_uas_moprog/features/record/record_track.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

Widget _wrapTrack({
  String initialSportName = 'Run',
  bool autoStart = false,
}) {
  return ProviderScope(
    child: MaterialApp(
      home: RecordTrackPage(
        initialSportName: initialSportName,
        autoStart: autoStart,
        enableLiveLocation: false,
        mapOverride: (_) => const ColoredBox(color: Colors.transparent),
      ),
    ),
  );
}

void main() {
  testWidgets(
      'displays collapsed framework with back button, telemetry, map controls, and 3-column bar',
      (tester) async {
    await tester.pumpWidget(_wrapTrack());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.text('Acquiring GPS'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('0.00 km'), findsOneWidget);
    expect(find.text('--.-'), findsOneWidget);

    expect(find.text('Run'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.text('Add Route'), findsOneWidget);

    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    expect(find.byIcon(Icons.explore), findsOneWidget);

    expect(find.text('Share live location'), findsNothing);
  });

  testWidgets('autoStart starts in recording state and play/pause toggles icon',
      (tester) async {
    await tester.pumpWidget(_wrapTrack(autoStart: true));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('tapping drag handle expands resizable menu to show extra options',
      (tester) async {
    await tester.pumpWidget(_wrapTrack());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('record_track_drag_handle')));
    await tester.pumpAndSettle();

    expect(find.text('Share live location'), findsOneWidget);
    expect(find.text('Navigation'), findsOneWidget);
    expect(find.text('Add a sensor'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(
      find.text('Audio cues, auto-pause, live segments'),
      findsOneWidget,
    );
  });

  testWidgets(
      'sport filter popup hides empty Your Top Sports, filters, and updates selected sport',
      (tester) async {
    await tester.pumpWidget(_wrapTrack(initialSportName: 'Run'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Run'));
    await tester.pumpAndSettle();

    expect(find.text('Filter by Sport'), findsOneWidget);
    expect(find.text('Your Top Sports'), findsNothing);
    expect(find.text('Foot Sports'), findsOneWidget);
    expect(find.text('Cycle Sports'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Trail Run');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trail Run').last);
    await tester.pumpAndSettle();

    expect(find.text('Filter by Sport'), findsNothing);
    expect(find.text('Trail Run'), findsOneWidget);
  });

  testWidgets('telemetry bar expands to full screen and collapses back',
      (tester) async {
    await tester.pumpWidget(_wrapTrack());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.open_in_full_rounded));
    await tester.pumpAndSettle();

    expect(find.text('TIME'), findsOneWidget);
    expect(find.text('DISTANCE (KM)'), findsOneWidget);
    expect(find.text('SPEED (KM/H)'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
    expect(find.text('Add Route'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_fullscreen_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
  });

  testWidgets('info and layers buttons open their respective modal sheets',
      (tester) async {
    await tester.pumpWidget(_wrapTrack());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();
    expect(find.text('Map data sources'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.layers_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Map Layers'), findsOneWidget);
    expect(find.text('Standard'), findsOneWidget);
    expect(find.text('Satellite'), findsOneWidget);
    expect(find.text('Hybrid'), findsOneWidget);
    expect(find.text('Global Run'), findsOneWidget);
    expect(find.text('Points of Interest'), findsOneWidget);
    expect(find.text('Bike Lanes'), findsOneWidget);
  });

  testWidgets('tapping Run card on Record page navigates to RecordTrackPage',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activityStoreProvider.overrideWithValue(MemoryActivityStore()),
          settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
        ],
        child: const MaterialApp(home: Record()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Run'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(RecordTrackPage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RecordTrackPage),
        matching: find.text('Run'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'More sports reuses Filter by Sport sheet and navigates with chosen sport',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activityStoreProvider.overrideWithValue(MemoryActivityStore()),
          settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
        ],
        child: const MaterialApp(home: Record()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('More sports'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Filter by Sport'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Swim');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Swim').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(RecordTrackPage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RecordTrackPage),
        matching: find.text('Swim'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'changing sport in RecordTrackPage keeps More sports sheet synced on back',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activityStoreProvider.overrideWithValue(MemoryActivityStore()),
          settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
        ],
        child: const MaterialApp(home: Record()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Run'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(RecordTrackPage), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(RecordTrackPage),
        matching: find.text('Run'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.enterText(find.byType(TextField), 'Trail Run');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Trail Run').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.descendant(
        of: find.byType(RecordTrackPage),
        matching: find.text('Trail Run'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('More sports'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final trailRunTile = find.ancestor(
      of: find.text('Trail Run'),
      matching: find.byType(ListTile),
    );
    expect(
      find.descendant(of: trailRunTile, matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );
  });
}
