import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';

class _FailingStore implements ActivityStore {
  @override
  Future<String?> read() => Future.error(Exception('read'));

  @override
  Future<void> write(String json) => Future.error(Exception('write'));
}

ManualActivity _activity(String id, DateTime date, {double km = 5}) {
  return ManualActivity(
    id: id,
    title: 'Title $id',
    type: ActivityType.run,
    date: date,
    duration: const Duration(minutes: 30),
    distanceKm: km,
  );
}

void main() {
  test('add mengurutkan dari yang terbaru dan menghitung total', () async {
    final controller = ActivityController(store: MemoryActivityStore());

    await controller.add(_activity('old', DateTime(2026, 11, 1)));
    await controller.add(_activity('new', DateTime(2026, 11, 10), km: 7));

    expect(controller.items.map((a) => a.id), ['new', 'old']);
    expect(controller.count, 2);
    expect(controller.totalDistanceKm, 12);
  });

  test('id yang sama menggantikan aktivitas lama', () async {
    final controller = ActivityController(store: MemoryActivityStore());

    await controller.add(_activity('a', DateTime(2026, 11, 1)));
    await controller.add(_activity('a', DateTime(2026, 11, 2), km: 9));

    expect(controller.count, 1);
    expect(controller.items.single.distanceKm, 9);
  });

  test('data bertahan setelah controller baru memuat dari store', () async {
    final store = MemoryActivityStore();
    final first = ActivityController(store: store);
    await first.add(_activity('a', DateTime(2026, 11, 1)));

    final second = ActivityController(store: store);
    await second.load();

    expect(second.isLoaded, isTrue);
    expect(second.items.single.id, 'a');
  });

  test('remove menghapus aktivitas dan memberi tahu listener', () async {
    final controller = ActivityController(store: MemoryActivityStore());
    await controller.add(_activity('a', DateTime(2026, 11, 1)));
    var calls = 0;
    controller.addListener(() => calls++);

    await controller.remove('missing');
    expect(calls, 0);

    await controller.remove('a');
    expect(controller.count, 0);
    expect(calls, 1);
  });

  test('JSON rusak menghasilkan daftar kosong tanpa error', () async {
    final controller = ActivityController(store: MemoryActivityStore('{oops'));

    await controller.load();

    expect(controller.isLoaded, isTrue);
    expect(controller.items, isEmpty);
  });

  test('penyimpanan gagal tidak membuat add atau load error', () async {
    final controller = ActivityController(store: _FailingStore());

    await controller.load();
    await controller.add(_activity('a', DateTime(2026, 11, 1)));

    expect(controller.count, 1);
  });
}