import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/strava_wordmark.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/upgrade_pill.dart';

Widget _wrap(PreferredSizeWidget header) {
  return MaterialApp(home: Scaffold(appBar: header));
}

void main() {
  testWidgets('menampilkan judul dan aksi', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppHeader(
          title: 'Groups',
          actions: [HeaderIconButton(icon: Icons.search)],
        ),
      ),
    );

    expect(find.text('Groups'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('badge tampil saat jumlah lebih dari nol', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppHeader(
          title: 'Home',
          actions: [
            HeaderIconButton(icon: Icons.notifications_none, badgeCount: 3),
          ],
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('badge tersembunyi saat jumlah nol', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppHeader(
          title: 'Home',
          actions: [HeaderIconButton(icon: Icons.notifications_none)],
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
  });

  testWidgets('menampilkan logo STRAVA sebagai judul', (tester) async {
    await tester.pumpWidget(
      _wrap(AppHeader(titleWidget: const StravaWordmark())),
    );

    expect(find.text('STRAVA'), findsOneWidget);
  });

  testWidgets('menampilkan tombol Upgrade di sisi kiri', (tester) async {
    await tester.pumpWidget(
      _wrap(AppHeader(leadingWidget: const UpgradePill())),
    );

    expect(find.text('Upgrade'), findsOneWidget);
  });

  testWidgets('menu tambah memanggil callback sesuai pilihan', (tester) async {
    AddAction? selected;

    await tester.pumpWidget(
      _wrap(
        AppHeader(
          actions: [AddMenuButton(onSelected: (a) => selected = a)],
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Post'), findsOneWidget);

    await tester.tap(find.text('Manual Activity'));
    await tester.pumpAndSettle();
    expect(selected, AddAction.manualActivity);
  });
}