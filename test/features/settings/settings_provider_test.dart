import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';

class _FailingStore implements SettingsStore {
  @override
  Future<String?> readString(String key) => Future.error(Exception('read'));

  @override
  Future<void> writeString(String key, String value) {
    return Future.error(Exception('write'));
  }

  @override
  Future<bool?> readBool(String key) => Future.error(Exception('read'));

  @override
  Future<void> writeBool(String key, bool value) {
    return Future.error(Exception('write'));
  }
}

ProviderContainer _container(SettingsStore store) {
  final container = ProviderContainer(
    overrides: [settingsStoreProvider.overrideWithValue(store)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('nilai awal: kilometer dan semua notifikasi aktif', () {
    final container = _container(MemorySettingsStore());
    final state = container.read(settingsProvider);

    expect(state.unit, SettingsDistanceUnit.kilometers);
    expect(state.isLoaded, isFalse);
    expect(state.enabledCount, NotificationPref.values.length);
  });

  test('load memulihkan satuan dan preferensi yang tersimpan', () async {
    final store = MemorySettingsStore();
    await store.writeString(SettingsNotifier.unitKey, 'miles');
    await store.writeBool(NotificationPref.followers.storageKey, false);

    final container = _container(store);
    await container.read(settingsProvider.notifier).load();

    final state = container.read(settingsProvider);
    expect(state.isLoaded, isTrue);
    expect(state.unit, SettingsDistanceUnit.miles);
    expect(state.isEnabled(NotificationPref.followers), isFalse);
    expect(state.enabledCount, 2);
  });

  test('satuan tersimpan yang tidak dikenal kembali ke kilometer', () async {
    final store = MemorySettingsStore();
    await store.writeString(SettingsNotifier.unitKey, 'parsec');

    final container = _container(store);
    await container.read(settingsProvider.notifier).load();

    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.kilometers);
  });

  test('perubahan tersimpan dan bertahan di container baru', () async {
    final store = MemorySettingsStore();
    final first = _container(store);
    await first.read(settingsProvider.notifier).setUnit(SettingsDistanceUnit.miles);
    await first
        .read(settingsProvider.notifier)
        .setNotification(NotificationPref.challenges, false);

    final second = _container(store);
    await second.read(settingsProvider.notifier).load();

    final state = second.read(settingsProvider);
    expect(state.unit, SettingsDistanceUnit.miles);
    expect(state.isEnabled(NotificationPref.challenges), isFalse);
  });

  test('listener hanya dipanggil saat nilainya berubah', () async {
    final container = _container(MemorySettingsStore());
    final notifier = container.read(settingsProvider.notifier);
    var calls = 0;
    container.listen<SettingsState>(settingsProvider, (_, __) => calls++);

    await notifier.setUnit(SettingsDistanceUnit.kilometers);
    await notifier.setNotification(NotificationPref.followers, true);
    await container.pump();
    expect(calls, 0);

    await notifier.setUnit(SettingsDistanceUnit.miles);
    await container.pump();
    expect(calls, 1);
  });

  test('penyimpanan gagal tidak membuat load atau setelan error', () async {
    final container = _container(_FailingStore());
    final notifier = container.read(settingsProvider.notifier);

    await notifier.load();
    expect(container.read(settingsProvider).isLoaded, isTrue);
    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.kilometers);

    await notifier.setUnit(SettingsDistanceUnit.miles);
    expect(container.read(settingsProvider).unit, SettingsDistanceUnit.miles);
  });
}