import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/clubs_tab.dart';

Widget _wrap(ClubsTab tab) {
  return MaterialApp(home: Scaffold(body: tab));
}

void main() {
  testWidgets('menampilkan daftar klub dari data dummy', (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    expect(find.text('Jakarta Sunrise Runners'), findsOneWidget);
    expect(find.text('46,090 runners • Jakarta'), findsOneWidget);
  });

  testWidgets('menampilkan keadaan kosong bila tidak ada klub', (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab(clubs: <Club>[])));

    expect(find.text('No clubs found'), findsOneWidget);
  });

  testWidgets('mengetuk klub membuka halaman detail', (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    await tester.tap(find.text('Jakarta Sunrise Runners'));
    await tester.pumpAndSettle();

    expect(find.text('Club'), findsOneWidget);
    expect(find.text('Join Club'), findsOneWidget);
  });

  testWidgets('mengetik di kolom cari menyaring daftar klub', (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    await tester.enterText(find.byType(TextField), 'swim');
    await tester.pump();

    expect(find.text('Bali Open Water Swimmers'), findsOneWidget);
    expect(find.text('Jakarta Sunrise Runners'), findsNothing);
  });

  testWidgets('kata kunci tanpa hasil menampilkan keadaan kosong',
      (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No clubs found'), findsOneWidget);
  });

  testWidgets('filter jenis olahraga menyaring daftar dan mengubah label',
      (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    await tester.tap(find.text('Sport type'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cycling'));
    await tester.pumpAndSettle();

    expect(find.text('Nusantara Cycling Club'), findsOneWidget);
    expect(find.text('Jakarta Sunrise Runners'), findsNothing);
    expect(find.text('Cycling'), findsOneWidget);
    expect(find.text('Sport type'), findsNothing);
  });

  testWidgets('filter lokasi menyaring daftar berdasarkan kota',
      (tester) async {
    await tester.pumpWidget(_wrap(const ClubsTab()));

    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bandung'));
    await tester.pumpAndSettle();

    expect(find.text('Bandung Trail Society'), findsOneWidget);
    expect(find.text('Jakarta Sunrise Runners'), findsNothing);
  });
}