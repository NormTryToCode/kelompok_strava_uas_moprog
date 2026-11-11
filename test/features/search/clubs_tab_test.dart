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
}