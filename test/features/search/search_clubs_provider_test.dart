import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_clubs_provider.dart';

class _StubClubsNotifier extends ClubsNotifier {
  final List<Club> clubs;

  _StubClubsNotifier(this.clubs);

  @override
  Future<List<Club>> build() async => clubs;
}

Club _groupClub({
  required String id,
  required String name,
  required ClubSport sport,
  int memberCount = 15,
  bool isGlobal = false,
  String city = 'Jakarta',
}) {
  return Club(
    id: id,
    name: name,
    description: 'Community club',
    sport: sport,
    types: const [],
    privacy: ClubPrivacy.public,
    isGlobal: isGlobal,
    location: isGlobal ? null : ClubLocation(name: city, detail: 'Indonesia'),
    memberCount: memberCount,
    createdAt: DateTime(2026, 11, 22),
  );
}

void main() {
  test('memetakan Club Firestore menjadi SearchClub dengan benar', () {
    final mapped = searchClubFromGroupClub(
      _groupClub(
        id: 'g1',
        name: 'Stride Cyclists',
        sport: ClubSport.option.firstWhere((s) => s.id == 'cycling'),
        memberCount: 25,
        city: 'Bandung',
      ),
    );

    expect(mapped.id, 'g1');
    expect(mapped.name, 'Stride Cyclists');
    expect(mapped.sport, SportType.cycling);
    expect(mapped.memberCount, 25);
    expect(mapped.city, 'Bandung,Indonesia');
    expect(mapped.isVerified, isTrue);
  });

  test('menggunakan data klub dari clubsProvider saat tersedia', () async {
    final container = ProviderContainer(
      overrides: [
        clubsProvider.overrideWith(
          () => _StubClubsNotifier([
            _groupClub(
              id: 'g1',
              name: 'Jakarta Night Runners',
              sport: ClubSport.option.firstWhere((s) => s.id == 'running'),
              memberCount: 12,
            ),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(clubsProvider.future);
    final result = container.read(searchClubsProvider);

    expect(result, hasLength(1));
    expect(result.single.name, 'Jakarta Night Runners');
    expect(result.single.sport, SportType.running);
  });

  test('mengembalikan daftar kosong saat clubsProvider kosong', () async {
    final container = ProviderContainer(
      overrides: [
        clubsProvider.overrideWith(() => _StubClubsNotifier(const [])),
      ],
    );
    addTearDown(container.dispose);

    await container.read(clubsProvider.future);
    expect(container.read(searchClubsProvider), isEmpty);
  });
}