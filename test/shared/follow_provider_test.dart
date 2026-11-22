import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('awal: daftar following kosong dan jumlah nol', () {
    final container = _container();

    expect(container.read(followProvider), isEmpty);
    expect(container.read(followingCountProvider), 0);
    expect(container.read(isFollowingProvider('a')), isFalse);
  });

  test('toggle menambah lalu menghapus id', () {
    final container = _container();
    final notifier = container.read(followProvider.notifier);

    notifier.toggle('a');
    expect(container.read(isFollowingProvider('a')), isTrue);
    expect(container.read(followingCountProvider), 1);

    notifier.toggle('a');
    expect(container.read(isFollowingProvider('a')), isFalse);
    expect(container.read(followingCountProvider), 0);
  });

  test('followingCountProvider memberi tahu listener saat berubah', () async {
    final container = _container();
    final counts = <int>[];
    container.listen<int>(
      followingCountProvider,
      (_, next) => counts.add(next),
      fireImmediately: true,
    );

    container.read(followProvider.notifier).toggle('a');
    await container.pump();
    container.read(followProvider.notifier).toggle('b');
    await container.pump();
    container.read(followProvider.notifier).toggle('a');
    await container.pump();

    expect(counts, [0, 1, 2, 1]);
  });
}