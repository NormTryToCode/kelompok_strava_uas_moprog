import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

void main() {
  test('initials memakai huruf pertama nama depan dan belakang', () {
    const person = Person(
      id: 'p',
      name: 'Dewi Anggraini',
      location: 'Bandung',
      tag: 't',
    );
    expect(person.initials, 'DA');
  });

  test('initials untuk satu kata memakai satu huruf', () {
    const person = Person(
      id: 'p',
      name: 'Rizky',
      location: 'Surabaya',
      tag: 't',
    );
    expect(person.initials, 'R');
  });
}