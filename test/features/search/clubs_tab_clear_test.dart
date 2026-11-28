import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/clubs_tab.dart';

const _fixtureClubs = [
  SearchClub(
    id: 'c1',
    name: 'Jakarta Sunrise Runners',
    sport: SportType.running,
    memberCount: 46090,
    city: 'Jakarta',
  ),
  SearchClub(
    id: 'c2',
    name: 'Nusantara Cycling Club',
    sport: SportType.cycling,
    memberCount: 22317,
    city: 'Jakarta',
  ),
  SearchClub(
    id: 'c3',
    name: 'Bali Open Water Swimmers',
    sport: SportType.swimming,
    memberCount: 8420,
    city: 'Denpasar',
  ),
  SearchClub(
    id: 'c4',
    name: 'Makassar Harbor Swim',
    sport: SportType.swimming,
    memberCount: 2140,
    city: 'Makassar',
  ),
];

Widget _wrap() {
  return const ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: SearchClubsTab(clubs: _fixtureClubs)),
    ),
  );
}

void main() {
  testWidgets('menampilkan jumlah klub dan tanpa tombol Clear filters',
      (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('4 clubs'), findsOneWidget);
    expect(find.text('Clear filters'), findsNothing);
  });

  testWidgets('jumlah klub ikut berubah saat disaring', (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.enterText(find.byType(TextField), 'swim');
    await tester.pump();

    expect(find.text('2 clubs'), findsOneWidget);
    expect(find.text('Clear filters'), findsOneWidget);
  });

  testWidgets('Clear filters mengosongkan kolom cari dan memulihkan daftar',
      (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.enterText(find.byType(TextField), 'swim');
    await tester.pump();
    await tester.tap(find.text('Clear filters'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.controller!.text, isEmpty);
    expect(find.text('4 clubs'), findsOneWidget);
    expect(find.text('Jakarta Sunrise Runners'), findsOneWidget);
    expect(find.text('Clear filters'), findsNothing);
  });

  testWidgets('Clear filters juga menghapus filter olahraga', (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.text('Sport type'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cycling'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear filters'));
    await tester.pump();

    expect(find.text('Sport type'), findsOneWidget);
    expect(find.text('4 clubs'), findsOneWidget);
  });
}