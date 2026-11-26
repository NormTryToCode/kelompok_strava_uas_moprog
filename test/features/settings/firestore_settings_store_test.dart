import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

void main() {
  test('membaca string dan bool dari Firestore saat tersedia', () async {
    final store = FirestoreSettingsStore(
      fallback: MemorySettingsStore(),
      readAll: (_) async => [
        {
          'id': FirestoreSettingsStore.docId,
          'distance_unit': 'miles',
          'notify_followers': false,
        },
      ],
      saveDoc: (_, _, _) async {},
    );

    expect(await store.readString('distance_unit'), 'miles');
    expect(await store.readBool('notify_followers'), isFalse);
  });

  test('fallback ke store lokal saat Firestore offline', () async {
    final fallback = MemorySettingsStore();
    await fallback.writeString('distance_unit', 'kilometers');
    final store = FirestoreSettingsStore(
      fallback: fallback,
      readAll: (_) => Future.error(Exception('offline')),
      saveDoc: (_, _, _) async {},
    );

    expect(await store.readString('distance_unit'), 'kilometers');
  });

  test('write menyinkronkan nilai ke lokal dan Firestore', () async {
    final fallback = MemorySettingsStore();
    SettingsJsonMap? saved;
    final store = FirestoreSettingsStore(
      fallback: fallback,
      readAll: (_) async => const [],
      saveDoc: (_, _, data) async => saved = data,
    );

    await store.writeString('distance_unit', 'miles');
    await store.writeBool('notify_challenges', false);

    expect(await fallback.readString('distance_unit'), 'miles');
    expect(saved?['distance_unit'], 'miles');
    expect(saved?['notify_challenges'], isFalse);
  });
}