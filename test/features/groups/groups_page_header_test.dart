import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/groups_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

Widget _wrap() {
  return ProviderScope(
    overrides: [
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
    ],
    child: const MaterialApp(home: GroupsPage()),
  );
}

void main() {
  testWidgets('menampilkan judul Groups dan tiga ikon aksi di header',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Groups'), findsOneWidget);
    expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('ikon cari membuka SearchPage', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('ikon pengaturan membuka SettingsPage', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
  });
}