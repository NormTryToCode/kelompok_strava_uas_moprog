import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

List<Club> buildDummyGroupClubs() {
  final sourceClubs = buildDummyClubs();
  final people = buildDummyPeople();
  final baseCreatedAt = DateTime(2026, 11, 1);

  const ownedClubIds = {'club1', 'club2'};

  return [
    for (var i = 0; i < sourceClubs.length; i++)
      _toGroupClub(
        source: sourceClubs[i],
        index: i,
        isOwner: ownedClubIds.contains(sourceClubs[i].id),
        memberIds: [
          for (var j = 0; j < people.length; j++)
            if ((i + j) % 2 == 0 || j < 3) people[j].id,
        ],
        createdAt: baseCreatedAt.subtract(Duration(days: i)),
      ),
  ];
}

Club _toGroupClub({
  required SearchClub source,
  required int index,
  required bool isOwner,
  required List<String> memberIds,
  required DateTime createdAt,
}) {
  return Club(
    id: source.id,
    name: source.name,
    description:
        'Official community sessions by ${source.name} in${source.city}. Open for athletes looking to train and connect together.',
    sport: ClubSport.byId(source.sport.name),
    types: [
      ClubType.option[index % ClubType.option.length],
      ClubType.option.last,
    ],
    privacy: ClubPrivacy.public,
    isGlobal: false,
    location: ClubLocation(name: source.city, detail: 'Indonesia'),
    memberCount: source.memberCount,
    isOwner: isOwner,
    isAdmin: isOwner,
    isJoined: isOwner,
    memberIds: memberIds,
    adminIds: const [],
    createdAt: createdAt,
  );
}