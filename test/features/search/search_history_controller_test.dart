import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_controller.dart';

void main() {
  test('add menaruh kueri terbaru di paling atas', () {
    final controller = SearchHistoryController();

    controller.add('run');
    controller.add('swim');

    expect(controller.items, ['swim', 'run']);
  });

  test('add memangkas spasi dan mengabaikan kueri kosong', () {
    final controller = SearchHistoryController();

    controller.add('  run  ');
    controller.add('   ');
    controller.add('');

    expect(controller.items, ['run']);
  });

  test('kueri sama tanpa peka huruf dipindah ke atas tanpa duplikat', () {
    final controller = SearchHistoryController();

    controller.add('Run');
    controller.add('swim');
    controller.add('run');

    expect(controller.items, ['run', 'swim']);
  });

  test('riwayat dibatasi maxItems dan yang tertua dibuang', () {
    final controller = SearchHistoryController(maxItems: 3);

    for (final query in ['a', 'b', 'c', 'd']) {
      controller.add(query);
    }

    expect(controller.items, ['d', 'c', 'b']);
  });

  test('remove menghapus satu kueri', () {
    final controller = SearchHistoryController(initial: ['a', 'b']);

    controller.remove('a');

    expect(controller.items, ['b']);
  });

  test('clear mengosongkan riwayat', () {
    final controller = SearchHistoryController(initial: ['a', 'b']);

    controller.clear();

    expect(controller.isEmpty, isTrue);
  });

  test('listener hanya dipanggil saat ada perubahan', () {
    final controller = SearchHistoryController();
    var calls = 0;
    controller.addListener(() => calls++);

    controller.add('   ');
    controller.remove('x');
    controller.clear();
    expect(calls, 0);

    controller.add('run');
    expect(calls, 1);

    controller.remove('run');
    expect(calls, 2);
  });

  test('items tidak bisa diubah dari luar', () {
    final controller = SearchHistoryController(initial: ['a']);

    expect(() => controller.items.add('b'), throwsUnsupportedError);
  });
}