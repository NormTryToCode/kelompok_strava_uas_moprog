import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_all.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_results_view.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

const _person = Person(
  id: 'p1',
  name: 'Dewi Anggraini',
  location: 'Bandung',
  tag: 'Local Legend near you',
);

const _club = Club(
  id: 'c1',
  name: 'Bandung Trail Society',
  sport: SportType.running,
  memberCount: 100,
  city: 'Bandung',
);

Widget _wrap(
  SearchResults results, {
  ValueChanged<Club>? onClubTap,
  ProviderContainer? container,
}) {
  final app = MaterialApp(
    home: Scaffold(
      body: SearchResultsView(
        results: results,
        onClubTap: onClubTap ?? (_) {},
      ),
    ),
  );
  if (container != null) {
    return UncontrolledProviderScope(container: container, child: app);
  }
  return ProviderScope(child: app);
}

void main() {
  testWidgets('menampilkan bagian PEOPLE dan CLUBS', (tester) async {
    await tester.pumpWidget(
      _wrap(const SearchResults(people: [_person], clubs: [_club])),
    );

    expect(find.text('PEOPLE'), findsOneWidget);
    expect(find.text('CLUBS'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
    expect(find.text('Bandung Trail Society'), findsOneWidget);
  });

  testWidgets('bagian tanpa hasil tidak ditampilkan', (tester) async {
    await tester.pumpWidget(
      _wrap(const SearchResults(people: [], clubs: [_club])),
    );

    expect(find.text('PEOPLE'), findsNothing);
    expect(find.text('CLUBS'), findsOneWidget);
  });

  testWidgets('tanpa hasil menampilkan pesan kosong', (tester) async {
    await tester.pumpWidget(
      _wrap(const SearchResults(people: [], clubs: [])),
    );

    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('mengetuk Follow mengubah tombol dan status', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _wrap(
        const SearchResults(people: [_person], clubs: []),
        container: container,
      ),
    );

    await tester.tap(find.text('Follow'));
    await tester.pump();

    expect(find.text('Following'), findsOneWidget);
    expect(container.read(isFollowingProvider('p1')), isTrue);
  });

  testWidgets('mengetuk klub memanggil onClubTap', (tester) async {
    Club? tapped;

    await tester.pumpWidget(
      _wrap(
        const SearchResults(people: [], clubs: [_club]),
        onClubTap: (club) => tapped = club,
      ),
    );

    await tester.tap(find.text('Bandung Trail Society'));

    expect(tapped?.id, 'c1');
  });
}