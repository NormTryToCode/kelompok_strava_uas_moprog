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
}