import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/club_tile.dart';

const _verified = Club(
  id: 'c1',
  name: 'Nusantara Cycling Club',
  sport: SportType.cycling,
  memberCount: 22317,
  city: 'Jakarta',
  isVerified: true,
);

const _plain = Club(
  id: 'c2',
  name: 'Bandung Trail Society',
  sport: SportType.running,
  memberCount: 15290,
  city: 'Bandung',
);

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('menampilkan nama, subtitle, dan lencana verifikasi',
      (tester) async {
    await tester.pumpWidget(_wrap(const ClubTile(club: _verified)));

    expect(find.text('Nusantara Cycling Club'), findsOneWidget);
    expect(find.text('22,317 cyclists • Jakarta'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
  });

  testWidgets('klub belum terverifikasi tidak punya lencana', (tester) async {
    await tester.pumpWidget(_wrap(const ClubTile(club: _plain)));

    expect(find.byIcon(Icons.verified), findsNothing);
  });

  testWidgets('onTap dipanggil saat tile diketuk', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(ClubTile(club: _plain, onTap: () => taps++)),
    );

    await tester.tap(find.text('Bandung Trail Society'));

    expect(taps, 1);
  });
}