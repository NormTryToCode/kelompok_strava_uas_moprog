import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

void main() {
  const club = Club(
    id: 'c',
    name: 'Jakarta Sunrise Runners',
    sport: SportType.running,
    memberCount: 46090,
    city: 'Jakarta',
  );

  test('memberLabel memakai pemisah ribuan dan kata sesuai olahraga', () {
    expect(club.memberLabel, '46,090 runners');
  });

  test('subtitle menggabungkan jumlah anggota dan kota', () {
    expect(club.subtitle, '46,090 runners • Jakarta');
  });

  test('initials memakai dua kata pertama', () {
    expect(club.initials, 'JS');
  });

  test('copyWith hanya mengganti jumlah anggota', () {
    final updated = club.copyWith(memberCount: 5);

    expect(updated.memberCount, 5);
    expect(updated.name, club.name);
    expect(updated.city, club.city);
  });
}