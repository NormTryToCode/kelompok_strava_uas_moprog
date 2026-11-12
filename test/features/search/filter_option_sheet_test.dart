import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/filter_option_sheet.dart';

Widget _sheet({String? selected, required ValueChanged<String?> onSelected}) {
  return MaterialApp(
    home: Scaffold(
      body: FilterOptionSheet<String>(
        title: 'Location',
        allLabel: 'All locations',
        options: const ['Bandung', 'Jakarta'],
        labelOf: (value) => value,
        selected: selected,
        onSelected: onSelected,
      ),
    ),
  );
}

void main() {
  testWidgets('menampilkan judul, pilihan semua, dan opsi', (tester) async {
    await tester.pumpWidget(_sheet(onSelected: (_) {}));

    expect(find.text('Location'), findsOneWidget);
    expect(find.text('All locations'), findsOneWidget);
    expect(find.text('Bandung'), findsOneWidget);
    expect(find.text('Jakarta'), findsOneWidget);
  });

  testWidgets('tanpa pilihan, baris semua yang bertanda centang',
      (tester) async {
    await tester.pumpWidget(_sheet(onSelected: (_) {}));

    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'All locations'),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('opsi terpilih bertanda centang', (tester) async {
    await tester.pumpWidget(_sheet(selected: 'Jakarta', onSelected: (_) {}));

    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Jakarta'),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('mengetuk opsi dan pilihan semua memanggil onSelected',
      (tester) async {
    String? picked = 'unset';

    await tester.pumpWidget(_sheet(onSelected: (value) => picked = value));

    await tester.tap(find.text('Bandung'));
    expect(picked, 'Bandung');

    await tester.tap(find.text('All locations'));
    expect(picked, isNull);
  });

  testWidgets('showFilterSheet menutup lembar setelah memilih', (tester) async {
    String? picked = 'unset';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showFilterSheet<String>(
                context: context,
                title: 'City',
                allLabel: 'All cities',
                options: const ['Bandung', 'Jakarta'],
                labelOf: (value) => value,
                selected: null,
                onSelected: (value) => picked = value,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('City'), findsOneWidget);

    await tester.tap(find.text('Jakarta'));
    await tester.pumpAndSettle();

    expect(picked, 'Jakarta');
    expect(find.text('City'), findsNothing);
  });
}