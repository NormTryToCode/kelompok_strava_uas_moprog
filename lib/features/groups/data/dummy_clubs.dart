import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/data/groups_seed_catalog.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

List<Club> buildDummyGroupClubs() {
  final sourceClubs = buildSeedClubs();
  final people = buildSeedPeople();
  final baseCreatedAt = DateTime(2026, 11, 1);

  return [
    for (var i = 0; i < sourceClubs.length; i++)
      _toGroupClub(
        source: sourceClubs[i],
        index: i,
        ownerId: people[i % people.length].id,
        isPrivate: sourceClubs[i].id == 'club2',
        memberIds: [
          people[i % people.length].id,
          for (var j = 0; j < people.length; j++)
            if ((i + j) % 2 == 0) people[j].id,
        ],
        pendingRequestIds: sourceClubs[i].id == 'club2'
            ? [
                for (final p in people)
                  if (p.id != people[i % people.length].id && p.id != 'p1')
                    p.id,
              ].take(2).toList()
            : const [],
        createdAt: baseCreatedAt.subtract(Duration(days: i)),
      ),
  ];
}

Club _toGroupClub({
  required SearchClub source,
  required int index,
  required String ownerId,
  required bool isPrivate,
  required List<String> memberIds,
  required List<String> pendingRequestIds,
  required DateTime createdAt,
}) {
  final cleanMembers = <String>{
    ownerId,
    ...memberIds.where((id) => !pendingRequestIds.contains(id)),
  }.toList();

  return Club(
    id: source.id,
    name: source.name,
    description:
        'Official community sessions by ${source.name} in ${source.city}. Open for athletes looking to train and connect together.',
    sport: ClubSport.byId(source.sport.name),
    types: [
      ClubType.option[index % ClubType.option.length],
      ClubType.option.last,
    ],
    privacy: isPrivate ? ClubPrivacy.private : ClubPrivacy.public,
    isGlobal: false,
    location: ClubLocation(name: source.city, detail: 'Indonesia'),
    ownerId: ownerId,
    memberCount: cleanMembers.length,
    isOwner: false,
    isAdmin: false,
    isJoined: false,
    memberIds: cleanMembers,
    adminIds: [ownerId],
    pendingRequestIds: pendingRequestIds,
    createdAt: createdAt,
  );
}