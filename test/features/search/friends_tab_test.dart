import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/friends_tab.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_store.dart';

const _fixturePeople = [
  Person(
    id: 'p1',
    name: 'Dewi Anggraini',
    location: 'Bandung, West Java',
    tag: 'Stride athlete',
  ),
  Person(
    id: 'p2',
    name: 'Rizky Pratama',
    location: 'Surabaya, East Java',
    tag: 'Stride athlete',
  ),
];

Widget _wrap({ProviderContainer? container}) {
  const app = MaterialApp(
    home: Scaffold(body: FriendsTab(people: _fixturePeople)),
  );
  if (container != null) {
    return UncontrolledProviderScope(container: container, child: app);
  }
  return ProviderScope(
    overrides: [followStoreProvider.overrideWithValue(MemoryFollowStore())],
    child: app,
  );
}

void main() {
  testWidgets('menampilkan daftar atlet', (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('PEOPLE YOU MAY KNOW'), findsOneWidget);
    expect(find.text('Dewi Anggraini'), findsOneWidget);
  });

  testWidgets('mengetuk Follow mengubah tombol menjadi Following',
      (tester) async {
    final container = ProviderContainer(
      overrides: [followStoreProvider.overrideWithValue(MemoryFollowStore())],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_wrap(container: container));

    expect(find.text('Following'), findsNothing);

    await tester.tap(find.text('Follow').first);
    await tester.pump();

    expect(find.text('Following'), findsOneWidget);
    expect(container.read(followingCountProvider), 1);
  });

  testWidgets('menampilkan sub-tab dan tombol Invite Friends', (tester) async {
    await tester.pumpWidget(_wrap());

    expect(find.text('Suggested'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('QR Code'), findsOneWidget);
    expect(find.text('Invite Friends'), findsOneWidget);
  });

  testWidgets('berpindah ke sub-tab QR Code', (tester) async {
    await tester.pumpWidget(_wrap());

    await tester.tap(find.text('QR Code'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('qr-code')), findsOneWidget);
  });
}