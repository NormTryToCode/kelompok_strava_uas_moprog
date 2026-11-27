import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_store.dart';

void main() {
  test('FirestoreSearchHistoryStore membaca riwayat dari Firestore sesuai uid',
      () async {
    final store = FirestoreSearchHistoryStore(
      fallback: MemorySearchHistoryStore(['local']),
      userId: () => 'uid_1',
      readAll: (_) async => [
        {
          'id': 'uid_1',
          'items': ['cycling', 'running'],
        },
      ],
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), ['cycling', 'running']);
  });

  test('FirestoreSearchHistoryStore fallback ke lokal saat Firestore offline',
      () async {
    final store = FirestoreSearchHistoryStore(
      fallback: MemorySearchHistoryStore(['bandung']),
      userId: () => 'uid_1',
      readAll: (_) => Future.error(Exception('offline')),
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), ['bandung']);
  });

  test('searchHistoryProvider memuat dan menyimpan perubahan ke store',
      () async {
    final store = MemorySearchHistoryStore(['trail']);
    final container = ProviderContainer(
      overrides: [searchHistoryStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    await container.read(searchHistoryProvider.notifier).load();
    expect(container.read(searchHistoryProvider), ['trail']);

    container.read(searchHistoryProvider.notifier).add('swim');
    await Future<void>.delayed(Duration.zero);
    expect(await store.read(), ['swim', 'trail']);
  });
}