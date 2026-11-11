import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';

void main() {
  test('angka di bawah seribu tanpa pemisah', () {
    expect(999.withThousands, '999');
  });

  test('angka ribuan memakai koma', () {
    expect(46090.withThousands, '46,090');
  });

  test('angka jutaan memakai dua koma', () {
    expect(1000000.withThousands, '1,000,000');
  });
}