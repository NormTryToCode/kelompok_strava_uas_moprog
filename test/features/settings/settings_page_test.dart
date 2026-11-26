import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_service.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

class _FakeAuthService implements AuthService {
  int signOutCalls = 0;

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void _tallScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(800, 2000);
  addTearDown(tester.view.reset);
}

ProviderContainer _container({
  SettingsStore? store,
  AuthService? authService,
}) {
  final container = ProviderContainer(
    overrides: [
      settingsStoreProvider.overrideWithValue(store ?? MemorySettingsStore()),
      authServiceProvider.overrideWithValue(authService ?? _FakeAuthService()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Widget _page({
  ProviderContainer? container,
  VoidCallback? onLogout,
  AuthService? authService,
}) {
  final app = MaterialApp(home: SettingsPage(onLogout: onLogout));
  if (container != null) {
    return UncontrolledProviderScope(container: container, child: app);
  }
  return ProviderScope(
    overrides: [
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      authServiceProvider.overrideWithValue(authService ?? _FakeAuthService()),
    ],
    child: app,
  );
}

void main() {
  testWidgets('menampilkan judul, bagian, dan menu', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pumpAndSettle();

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
    await store.writeString(SettingsNotifier.unitKey, 'miles');
    final container = _container(store: store);

    await tester.pumpWidget(_page(container: container));
    await tester.pumpAndSettle();

    expect(find.text('Miles'), findsOneWidget);
  });

  testWidgets('memilih Miles mengubah subtitle', (tester) async {
    _tallScreen(tester);
    final container = _container();

    await tester.pumpWidget(_page(container: container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Units of measurement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)'));
    await tester.pumpAndSettle();

    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.miles);
    expect(find.text('Miles'), findsOneWidget);
  });

  testWidgets('menu Notification preferences membuka halaman preferensi',
      (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notification preferences'));
    await tester.pumpAndSettle();

    expect(find.text('PUSH NOTIFICATIONS'), findsOneWidget);
  });

  testWidgets('Cancel menutup dialog tanpa memanggil onLogout',
      (tester) async {
    _tallScreen(tester);
    var calls = 0;

    await tester.pumpWidget(_page(onLogout: () => calls++));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsNothing);
    expect(calls, 0);
  });

  testWidgets('konfirmasi memanggil signOut dan onLogout satu kali',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService();
    var calls = 0;

    await tester.pumpWidget(
      _page(onLogout: () => calls++, authService: fakeAuth),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();

    expect(fakeAuth.signOutCalls, 1);
    expect(calls, 1);
  });

  testWidgets('tanpa onLogout, konfirmasi memanggil signOut dan kembali ke root',
      (tester) async {
    _tallScreen(tester);
    final fakeAuth = _FakeAuthService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
          authServiceProvider.overrideWithValue(fakeAuth),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsPage(),
                  ),
                ),
                child: const Text('Open Settings'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();

    expect(fakeAuth.signOutCalls, 1);
    expect(find.text('Open Settings'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('Privacy controls mengubah subtitle sesuai pilihan',
      (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy controls'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Followers only'));
    await tester.pumpAndSettle();

    expect(find.text('Followers only'), findsOneWidget);
  });

  testWidgets('Help center menampilkan sheet panduan', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Help center'));
    await tester.pumpAndSettle();

    expect(find.text('Close'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
  });

  testWidgets('About menampilkan informasi versi Stride', (tester) async {
    _tallScreen(tester);
    await tester.pumpWidget(_page());
    await tester.pumpAndSettle();

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About Stride'), findsOneWidget);
  });
}