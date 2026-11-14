import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/recent_searches_list.dart';

Widget _wrap(RecentSearchesList list) {
  return MaterialApp(home: Scaffold(body: list));
}

void main() {
  testWidgets('menampilkan judul, tombol Clear all, dan item riwayat',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        RecentSearchesList(
          items: const ['dewi', 'swim'],
          onSelect: (_) {},
          onRemove: (_) {},
          onClear: () {},
        ),
      ),
    );

    expect(find.text('RECENT SEARCHES'), findsOneWidget);
    expect(find.text('Clear all'), findsOneWidget);
    expect(find.text('dewi'), findsOneWidget);
    expect(find.text('swim'), findsOneWidget);
  });

  testWidgets('daftar kosong tidak menampilkan apa pun', (tester) async {
    await tester.pumpWidget(
      _wrap(
        RecentSearchesList(
          items: const [],
          onSelect: (_) {},
          onRemove: (_) {},
          onClear: () {},
        ),
      ),
    );

    expect(find.text('RECENT SEARCHES'), findsNothing);
    expect(find.text('Clear all'), findsNothing);
  });

  testWidgets('mengetuk item memanggil onSelect', (tester) async {
    String? selected;

    await tester.pumpWidget(
      _wrap(
        RecentSearchesList(
          items: const ['dewi', 'swim'],
          onSelect: (value) => selected = value,
          onRemove: (_) {},
          onClear: () {},
        ),
      ),
    );

    await tester.tap(find.text('swim'));

    expect(selected, 'swim');
  });

  testWidgets('ikon tutup memanggil onRemove dengan kueri yang benar',
      (tester) async {
    String? removed;

    await tester.pumpWidget(
      _wrap(
        RecentSearchesList(
          items: const ['dewi', 'swim'],
          onSelect: (_) {},
          onRemove: (value) => removed = value,
          onClear: () {},
        ),
      ),
    );

    await tester.tap(find.byTooltip('Remove swim'));

    expect(removed, 'swim');
  });

  testWidgets('Clear all memanggil onClear', (tester) async {
    var calls = 0;

    await tester.pumpWidget(
      _wrap(
        RecentSearchesList(
          items: const ['dewi'],
          onSelect: (_) {},
          onRemove: (_) {},
          onClear: () => calls++,
        ),
      ),
    );

    await tester.tap(find.text('Clear all'));

    expect(calls, 1);
  });
}