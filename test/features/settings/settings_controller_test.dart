import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_controller.dart';
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

void main() {
  test('nilai awal: kilometer dan semua notifikasi aktif', () {
    final controller = SettingsController(store: MemorySettingsStore());

    expect(controller.unit, DistanceUnit.kilometers);
    expect(controller.isLoaded, isFalse);
    expect(controller.enabledCount, NotificationPref.values.length);
  });

  test('load memulihkan satuan dan preferensi yang tersimpan', () async {
    final store = MemorySettingsStore();
    await store.writeString(SettingsController.unitKey, 'miles');
    await store.writeBool(NotificationPref.followers.storageKey, false);

    final controller = SettingsController(store: store);
    await controller.load();

    expect(controller.isLoaded, isTrue);
    expect(controller.unit, DistanceUnit.miles);
    expect(controller.isEnabled(NotificationPref.followers), isFalse);
    expect(controller.enabledCount, 2);
  });

  test('satuan tersimpan yang tidak dikenal kembali ke kilometer', () async {
    final store = MemorySettingsStore();
    await store.writeString(SettingsController.unitKey, 'parsec');

    final controller = SettingsController(store: store);
    await controller.load();

    expect(controller.unit, DistanceUnit.kilometers);
  });

  test('perubahan tersimpan dan bertahan di controller baru', () async {
    final store = MemorySettingsStore();
    final first = SettingsController(store: store);
    await first.setUnit(DistanceUnit.miles);
    await first.setNotification(NotificationPref.challenges, false);

    final second = SettingsController(store: store);
    await second.load();

    expect(second.unit, DistanceUnit.miles);
    expect(second.isEnabled(NotificationPref.challenges), isFalse);
  });

  test('listener hanya dipanggil saat nilainya berubah', () async {
    final controller = SettingsController(store: MemorySettingsStore());
    var calls = 0;
    controller.addListener(() => calls++);

    await controller.setUnit(DistanceUnit.kilometers);
    await controller.setNotification(NotificationPref.followers, true);
    expect(calls, 0);

    await controller.setUnit(DistanceUnit.miles);
    expect(calls, 1);
  });

  test('penyimpanan gagal tidak membuat load atau setelan error', () async {
    final controller = SettingsController(store: _FailingStore());

    await controller.load();

    expect(controller.isLoaded, isTrue);
    expect(controller.unit, DistanceUnit.kilometers);

    await controller.setUnit(DistanceUnit.miles);

    expect(controller.unit, DistanceUnit.miles);
  });
}