import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

void main() {
  test('nilai yang ditulis bisa dibaca kembali', () async {
    final store = MemorySettingsStore();

    await store.writeString('unit', 'miles');
    await store.writeBool('push', false);

    expect(await store.readString('unit'), 'miles');
    expect(await store.readBool('push'), isFalse);
  });

  test('kunci yang belum ada menghasilkan null', () async {
    final store = MemorySettingsStore();

    expect(await store.readString('x'), isNull);
    expect(await store.readBool('x'), isNull);
  });

  test('tipe yang tidak cocok dibaca sebagai null', () async {
    final store = MemorySettingsStore();

    await store.writeString('k', 'text');

    expect(await store.readBool('k'), isNull);
  });
}