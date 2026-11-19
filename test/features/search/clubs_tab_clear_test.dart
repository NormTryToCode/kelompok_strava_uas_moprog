import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/clubs_tab.dart';

Widget _wrap() {
  return const MaterialApp(home: Scaffold(body: ClubsTab()));
}

void main() {
  testWidgets('menampilkan jumlah klub dan tanpa tombol Clear filters',
      (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('10 clubs'), findsOneWidget);
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
    expect(find.text('10 clubs'), findsOneWidget);
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
    expect(find.text('10 clubs'), findsOneWidget);
  });
}