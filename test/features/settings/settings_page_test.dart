import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 2000);
  addTearDown(tester.view.reset);
}

Widget _page({VoidCallback? onLogout}) {
  return MaterialApp(home: SettingsPage(onLogout: onLogout));
}

void main() {
  testWidgets('menampilkan judul, bagian, dan menu', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('SUPPORT'), findsOneWidget);
    expect(find.text('Privacy controls'), findsOneWidget);
    expect(find.text('Units of measurement'), findsOneWidget);
    expect(find.text('Kilometers'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('mengetuk menu menampilkan pesan Coming soon', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());

    await tester.tap(find.text('Privacy controls'));
    await tester.pump();

    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Log out menampilkan dialog konfirmasi', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Cancel menutup dialog tanpa memanggil onLogout', (tester) async {
    _tallScreen(tester);
    var calls = 0;

    await tester.pumpWidget(_page(onLogout: () => calls++));

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsNothing);
    expect(calls, 0);
  });

  testWidgets('konfirmasi memanggil onLogout satu kali', (tester) async {
    _tallScreen(tester);
    var calls = 0;

    await tester.pumpWidget(_page(onLogout: () => calls++));

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsNothing);
    expect(calls, 1);
  });
}