import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_provider.dart';

ProviderContainer _container({List<String>? initial, int maxItems = 8}) {
  final container = ProviderContainer(
    overrides: [
      searchHistoryProvider.overrideWith(
        () => SearchHistoryNotifier(initial: initial, maxItems: maxItems),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('add menaruh kueri terbaru di paling atas', () {
    final container = _container();
    final notifier = container.read(searchHistoryProvider.notifier);

    notifier.add('run');
    notifier.add('swim');

    expect(container.read(searchHistoryProvider), ['swim', 'run']);
  });

  test('add memangkas spasi dan mengabaikan kueri kosong', () {
    final container = _container();
    final notifier = container.read(searchHistoryProvider.notifier);

    notifier.add('  run  ');
    notifier.add('   ');
    notifier.add('');

    expect(container.read(searchHistoryProvider), ['run']);
  });

  test('kueri sama tanpa peka huruf dipindah ke atas tanpa duplikat', () {
    final container = _container();
    final notifier = container.read(searchHistoryProvider.notifier);

    notifier.add('Run');
    notifier.add('swim');
    notifier.add('run');

    expect(container.read(searchHistoryProvider), ['run', 'swim']);
  });

  test('riwayat dibatasi maxItems dan yang tertua dibuang', () {
    final container = _container(maxItems: 3);
    final notifier = container.read(searchHistoryProvider.notifier);

    for (final query in ['a', 'b', 'c', 'd']) {
      notifier.add(query);
    }

    expect(container.read(searchHistoryProvider), ['d', 'c', 'b']);
  });

  test('remove menghapus satu kueri', () {
    final container = _container(initial: ['a', 'b']);

    container.read(searchHistoryProvider.notifier).remove('a');

    expect(container.read(searchHistoryProvider), ['b']);
  });

  test('clear mengosongkan riwayat', () {
    final container = _container(initial: ['a', 'b']);

    container.read(searchHistoryProvider.notifier).clear();

    expect(container.read(searchHistoryProvider), isEmpty);
  });

  test('listener hanya dipanggil saat ada perubahan', () async {
    final container = _container();
    final notifier = container.read(searchHistoryProvider.notifier);
    var calls = 0;
    container.listen<List<String>>(
      searchHistoryProvider,
      (_, _) => calls++,
    );

    notifier.add('   ');
    notifier.remove('x');
    notifier.clear();
    await container.pump();
    expect(calls, 0);

    notifier.add('run');
    await container.pump();
    expect(calls, 1);

    notifier.remove('run');
    await container.pump();
    expect(calls, 2);
  });

  test('daftar riwayat tidak bisa diubah dari luar', () {
    final container = _container(initial: ['a']);

    expect(
      () => container.read(searchHistoryProvider).add('b'),
      throwsUnsupportedError,
    );
  });
}