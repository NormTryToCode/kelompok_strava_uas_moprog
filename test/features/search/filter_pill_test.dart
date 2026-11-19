import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/filter_pill.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  testWidgets('menampilkan label dan memanggil onTap', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(FilterPill(label: 'Location', onTap: () => taps++)),
    );

    expect(find.text('Location'), findsOneWidget);

    await tester.tap(find.text('Location'));

    expect(taps, 1);
  });

  testWidgets('menampilkan ikon awal bila diberikan', (tester) async {
    await tester.pumpWidget(
      _wrap(
        FilterPill(
          label: 'Location',
          icon: Icons.location_on_outlined,
          onTap: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
  });

  testWidgets('tanpa ikon hanya menampilkan panah', (tester) async {
    await tester.pumpWidget(
      _wrap(FilterPill(label: 'Sport type', onTap: () {})),
    );

    expect(find.byIcon(Icons.location_on_outlined), findsNothing);
    expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
  });
}