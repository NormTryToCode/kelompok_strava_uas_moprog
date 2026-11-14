import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

const _club = Club(
  id: 'c1',
  name: 'Jakarta Sunrise Runners',
  sport: SportType.running,
  memberCount: 1000,
  city: 'Jakarta',
);

Widget _page() => const MaterialApp(home: ClubDetailPage(club: _club));

void main() {
  testWidgets('menampilkan informasi klub', (tester) async {
    await tester.pumpWidget(_page());

    expect(find.text('Jakarta Sunrise Runners'), findsOneWidget);
    expect(find.text('1,000 runners • Jakarta'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Join Club'), findsOneWidget);
  });

  testWidgets('Join Club menambah anggota dan berubah menjadi Joined',
      (tester) async {
    await tester.pumpWidget(_page());

    await tester.tap(find.text('Join Club'));
    await tester.pump();

    expect(find.text('Joined'), findsOneWidget);
    expect(find.text('1,001 runners • Jakarta'), findsOneWidget);
  });

  testWidgets('mengetuk Joined membatalkan keanggotaan', (tester) async {
    await tester.pumpWidget(_page());

    await tester.tap(find.text('Join Club'));
    await tester.pump();
    await tester.tap(find.text('Joined'));
    await tester.pump();

    expect(find.text('Join Club'), findsOneWidget);
    expect(find.text('1,000 runners • Jakarta'), findsOneWidget);
  });
}