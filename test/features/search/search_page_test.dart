import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';

void main() {
  testWidgets('menampilkan tab Friends dan Clubs', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('Clubs'), findsOneWidget);
    expect(find.text('Search Strava'), findsOneWidget);
  });

  testWidgets('tab Clubs menampilkan kolom cari klub dan filter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));

    await tester.tap(find.text('Clubs'));
    await tester.pumpAndSettle();

    expect(find.text('Find clubs...'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Sport type'), findsOneWidget);
  });
}