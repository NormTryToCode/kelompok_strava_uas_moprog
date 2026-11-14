import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

Widget _wrap(SearchHistoryController history) {
  return MaterialApp(
    home: Scaffold(
      body: FriendsTab(controller: FollowController(), history: history),
    ),
  );
}

void main() {
  testWidgets('mengetik kueri menampilkan hasil orang', (tester) async {
    await tester.pumpWidget(_wrap(SearchHistoryController()));

    await tester.enterText(find.byType(TextField), 'dewi');
    await tester.pump();

    expect(find.text('PEOPLE'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
    expect(find.text('Invite Friends'), findsNothing);
  });

  testWidgets('kueri yang cocok klub menampilkan bagian CLUBS',
      (tester) async {
    await tester.pumpWidget(_wrap(SearchHistoryController()));

    await tester.enterText(find.byType(TextField), 'swim');
    await tester.pump();

    expect(find.text('CLUBS'), findsOneWidget);
    expect(find.text('Bali Open Water Swimmers'), findsOneWidget);
  });

  testWidgets('kueri tanpa kecocokan menampilkan pesan kosong',
      (tester) async {
    await tester.pumpWidget(_wrap(SearchHistoryController()));

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('menekan tombol cari menyimpan kueri ke riwayat', (tester) async {
    final history = SearchHistoryController();

    await tester.pumpWidget(_wrap(history));

    await tester.enterText(find.byType(TextField), 'dewi');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(history.items, ['dewi']);
  });

  testWidgets('kolom fokus dan kosong menampilkan riwayat pencarian',
      (tester) async {
    await tester.pumpWidget(
      _wrap(SearchHistoryController(initial: ['dewi'])),
    );

    expect(find.text('RECENT SEARCHES'), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.text('RECENT SEARCHES'), findsOneWidget);
    expect(find.text('dewi'), findsOneWidget);
    expect(find.text('Invite Friends'), findsNothing);
  });

  testWidgets('mengetuk item riwayat mengisi kolom dan menampilkan hasil',
      (tester) async {
    await tester.pumpWidget(
      _wrap(SearchHistoryController(initial: ['dewi'])),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.text('dewi'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));

    expect(field.controller!.text, 'dewi');
    expect(find.text('PEOPLE'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
  });

  testWidgets('menghapus satu riwayat lewat ikon tutup', (tester) async {
    final history = SearchHistoryController(initial: ['dewi']);

    await tester.pumpWidget(_wrap(history));

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.byTooltip('Remove dewi'));
    await tester.pump();

    expect(history.isEmpty, isTrue);
    expect(find.text('RECENT SEARCHES'), findsNothing);
  });

  testWidgets('Clear all mengosongkan riwayat', (tester) async {
    final history = SearchHistoryController(initial: ['a', 'b']);

    await tester.pumpWidget(_wrap(history));

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.text('Clear all'));
    await tester.pump();

    expect(history.isEmpty, isTrue);
  });

  testWidgets('mengetuk klub di hasil membuka halaman detail', (tester) async {
    await tester.pumpWidget(_wrap(SearchHistoryController()));

    await tester.enterText(find.byType(TextField), 'swim');
    await tester.pump();
    await tester.tap(find.text('Bali Open Water Swimmers'));
    await tester.pumpAndSettle();

    expect(find.text('Join Club'), findsOneWidget);
  });
}