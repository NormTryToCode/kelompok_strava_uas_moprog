import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';

void main() {
  test('membaca payload dari Firestore saat dokumen tersedia', () async {
    final fallback = MemoryActivityStore('["local"]');
    final store = FirestoreActivityStore(
      fallback: fallback,
      readAll: (_) async => [
        {'id': FirestoreActivityStore.docId, 'payload': '["remote"]'},
      ],
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), '["remote"]');
  });

  test('fallback ke store lokal saat Firestore gagal membaca', () async {
    final fallback = MemoryActivityStore('["local"]');
    final store = FirestoreActivityStore(
      fallback: fallback,
      readAll: (_) => Future.error(Exception('offline')),
      saveDoc: (_, _, _) async {},
    );

    expect(await store.read(), '["local"]');
  });

  test('write menyimpan ke lokal dan Firestore sekaligus', () async {
    final fallback = MemoryActivityStore();
    Map<String, dynamic>? saved;
    final store = FirestoreActivityStore(
      fallback: fallback,
      readAll: (_) async => const [],
      saveDoc: (_, _, data) async => saved = data,
    );

    await store.write('[{"id":"a1"}]');

    expect(await fallback.read(), '[{"id":"a1"}]');
    expect(saved?['payload'], '[{"id":"a1"}]');
  });
}