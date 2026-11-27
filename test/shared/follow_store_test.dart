import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_store.dart';

void main() {
  test('FirestoreFollowStore membaca daftar id dari Firestore sesuai uid',
      () async {
    final store = FirestoreFollowStore(
      fallback: MemoryFollowStore({'local'}),
      userId: () => 'uid_1',
      readAll: (_) async => [
        {
          'id': 'uid_1',
          'ids': ['p1', 'p2'],
        },
      ],
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), {'p1', 'p2'});
  });

  test('FirestoreFollowStore fallback ke store lokal saat Firestore offline',
      () async {
    final store = FirestoreFollowStore(
      fallback: MemoryFollowStore({'p9'}),
      userId: () => 'uid_1',
      readAll: (_) => Future.error(Exception('offline')),
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), {'p9'});
  });

  test('followProvider memuat dan menyimpan perubahan ke followStoreProvider',
      () async {
    final store = MemoryFollowStore({'p1'});
    final container = ProviderContainer(
      overrides: [followStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container.read(followProvider.notifier).load();
    expect(container.read(followProvider), {'p1'});

    container.read(followProvider.notifier).toggle('p2');
    await Future<void>.delayed(Duration.zero);
    expect(await store.read(), {'p1', 'p2'});
  });
}