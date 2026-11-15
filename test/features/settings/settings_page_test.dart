import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 2000);
  addTearDown(tester.view.reset);
}

SettingsController _controller() {
  return SettingsController(store: MemorySettingsStore());
}

Widget _page({SettingsController? controller, VoidCallback? onLogout}) {
  return MaterialApp(
    home: SettingsPage(
      controller: controller ?? _controller(),
      onLogout: onLogout,
    ),
  );
}

void main() {
  testWidgets('menampilkan judul, bagian, dan menu', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Units of measurement'), findsOneWidget);
    expect(find.text('Kilometers'), findsOneWidget);
    expect(find.text('3 of 3 on'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('satuan tersimpan ditampilkan sebagai subtitle', (tester) async {
    _tallScreen(tester);
    final store = MemorySettingsStore();
    await store.writeString(SettingsController.unitKey, 'miles');

    await tester.pumpWidget(
      _page(controller: SettingsController(store: store)),
    );
    await tester.pump();

    expect(find.text('Miles'), findsOneWidget);
  });

  testWidgets('memilih Miles mengubah subtitle', (tester) async {
    _tallScreen(tester);
    final controller = _controller();

    await tester.pumpWidget(_page(controller: controller));
    await tester.pump();

    await tester.tap(find.text('Units of measurement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)'));
    await tester.pumpAndSettle();

    expect(controller.unit, DistanceUnit.miles);
    expect(find.text('Miles'), findsOneWidget);
  });

  testWidgets('menu Notification preferences membuka halaman preferensi',
      (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pump();

    await tester.tap(find.text('Notification preferences'));
    await tester.pumpAndSettle();

    expect(find.text('PUSH NOTIFICATIONS'), findsOneWidget);
  });

  testWidgets('Cancel menutup dialog tanpa memanggil onLogout',
      (tester) async {
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

    expect(calls, 1);
  });

  testWidgets('tanpa onLogout, konfirmasi kembali ke halaman login',
      (tester) async {
    _tallScreen(tester);

    await tester.pumpWidget(_page());

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome User'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });
}