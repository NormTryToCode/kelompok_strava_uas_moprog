import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/clubs_result_bar.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('menampilkan jumlah klub dalam bentuk jamak', (tester) async {
    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 5, isFiltered: false, onClear: () {})),
    );

    expect(find.text('5 clubs'), findsOneWidget);
  });

  testWidgets('satu klub memakai bentuk tunggal', (tester) async {
    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 1, isFiltered: false, onClear: () {})),
    );

    expect(find.text('1 club'), findsOneWidget);
  });

  testWidgets('nol klub tetap memakai bentuk jamak', (tester) async {
    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 0, isFiltered: false, onClear: () {})),
    );

    expect(find.text('0 clubs'), findsOneWidget);
  });

  testWidgets('tombol Clear filters hanya tampil saat difilter',
      (tester) async {
    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 5, isFiltered: false, onClear: () {})),
    );

    expect(find.text('Clear filters'), findsNothing);

    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 5, isFiltered: true, onClear: () {})),
    );

    expect(find.text('Clear filters'), findsOneWidget);
  });

  testWidgets('mengetuk Clear filters memanggil onClear', (tester) async {
    var calls = 0;

    await tester.pumpWidget(
      _wrap(ClubsResultBar(count: 5, isFiltered: true, onClear: () => calls++)),
    );

    await tester.tap(find.text('Clear filters'));

    expect(calls, 1);
  });
}