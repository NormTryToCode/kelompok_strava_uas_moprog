import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';

enum SportType {
  running('Running', 'runners'),
  cycling('Cycling', 'cyclists'),
  swimming('Swimming', 'swimmers'),
  walking('Walking', 'walkers');

  final String label;
  final String memberNoun;

  const SportType(this.label, this.memberNoun);
}

class SearchClub {
  final String id;
  final String name;
  final SportType sport;
  final int memberCount;
  final String city;
  final bool isVerified;
  final String? avatarPath;

  const SearchClub({
    required this.id,
    required this.name,
    required this.sport,
    required this.memberCount,
    required this.city,
    this.isVerified = false,
    this.avatarPath,
  });

  String get memberLabel => '${memberCount.withThousands} ${sport.memberNoun}';

  String get subtitle => '$memberLabel • $city';

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  SearchClub copyWith({int? memberCount, String? avatarPath}) {
    return SearchClub(
      id: id,
      name: name,
      sport: sport,
      memberCount: memberCount ?? this.memberCount,
      city: city,
      isVerified: isVerified,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}