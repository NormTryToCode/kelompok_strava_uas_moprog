import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
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

ProviderContainer _container(ActivityStore store) {
  final container = ProviderContainer(
    overrides: [activityStoreProvider.overrideWithValue(store)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('add mengurutkan dari yang terbaru dan menghitung total', () async {
    final container = _container(MemoryActivityStore());
    final notifier = container.read(activityProvider.notifier);

    await notifier.add(_activity('old', DateTime(2026, 11, 1)));
    await notifier.add(_activity('new', DateTime(2026, 11, 10), km: 7));

    final state = container.read(activityProvider);
    expect(state.items.map((a) => a.id), ['new', 'old']);
    expect(state.count, 2);
    expect(state.totalDistanceKm, 12);
  });

  test('id yang sama menggantikan aktivitas lama', () async {
    final container = _container(MemoryActivityStore());
    final notifier = container.read(activityProvider.notifier);

    await notifier.add(_activity('a', DateTime(2026, 11, 1)));
    await notifier.add(_activity('a', DateTime(2026, 11, 2), km: 9));

    final state = container.read(activityProvider);
    expect(state.count, 1);
    expect(state.items.single.distanceKm, 9);
  });

  test('data bertahan setelah container baru memuat dari store', () async {
    final store = MemoryActivityStore();
    final first = _container(store);
    await first
        .read(activityProvider.notifier)
        .add(_activity('a', DateTime(2026, 11, 1)));

    final second = _container(store);
    await second.read(activityProvider.notifier).load();

    final state = second.read(activityProvider);
    expect(state.isLoaded, isTrue);
    expect(state.items.single.id, 'a');
  });

  test('remove menghapus aktivitas dan memberi tahu listener', () async {
    final container = _container(MemoryActivityStore());
    final notifier = container.read(activityProvider.notifier);
    await notifier.add(_activity('a', DateTime(2026, 11, 1)));

    var calls = 0;
    container.listen<ActivityState>(activityProvider, (_, _) => calls++);

    await notifier.remove('missing');
    await container.pump();
    expect(calls, 0);

    await notifier.remove('a');
    await container.pump();
    expect(container.read(activityProvider).count, 0);
    expect(calls, 1);
  });

  test('JSON rusak menghasilkan daftar kosong tanpa error', () async {
    final container = _container(MemoryActivityStore('{oops'));

    await container.read(activityProvider.notifier).load();

    final state = container.read(activityProvider);
    expect(state.isLoaded, isTrue);
    expect(state.items, isEmpty);
  });

  test('penyimpanan gagal tidak membuat add atau load error', () async {
    final container = _container(_FailingStore());
    final notifier = container.read(activityProvider.notifier);

    await notifier.load();
    await notifier.add(_activity('a', DateTime(2026, 11, 1)));

    expect(container.read(activityProvider).count, 1);
  });
}