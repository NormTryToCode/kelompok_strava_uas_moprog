import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/unit_picker_sheet.dart';

void main() {
  testWidgets('menampilkan semua satuan dan menandai yang terpilih',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UnitPickerSheet(
            selected: SettingsDistanceUnit.miles,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Kilometers (km)'), findsOneWidget);
    expect(find.text('Miles (mi)'), findsOneWidget);
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Miles (mi)'),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('showUnitPicker mengubah satuan dan menutup lembar',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showUnitPicker(context, ref),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)'));
    await tester.pumpAndSettle();

    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.miles);
    expect(find.text('Units of measurement'), findsNothing);
  });
}