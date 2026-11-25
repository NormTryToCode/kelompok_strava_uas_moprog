import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

enum ChallengeMetric { distanceKm, elevationMeters, movingMinutes, activeDays }

enum ChallengeScope { community, club, friendsGroup }

class ChallengeReward {
  final String badgeCode;
  final String badgeTitle;
  final String description;
  final int points;

  const ChallengeReward({
    required this.badgeCode,
    required this.badgeTitle,
    required this.description,
    this.points = 100,
  });

  Map<String, dynamic> toJson() => {
        'badgeCode': badgeCode,
        'badgeTitle': badgeTitle,
        'description': description,
        'points': points,
      };

  factory ChallengeReward.fromJson(Map<String, dynamic> json) {
    return ChallengeReward(
      badgeCode: json['badgeCode'] as String? ?? '',
      badgeTitle: json['badgeTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      points: (json['points'] as num?)?.toInt() ?? 100,
    );
  }
}

class ChallengeLeaderboardEntry {
  final String userId;
  final String athleteName;
  final String? location;
  final double progressValue;
  final bool isFollowing;
  final DateTime updatedAt;

  const ChallengeLeaderboardEntry({
    required this.userId,
    required this.athleteName,
    this.location,
    required this.progressValue,
    this.isFollowing = false,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'athleteName': athleteName,
        'location': location,
        'progressValue': progressValue,
        'isFollowing': isFollowing,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ChallengeLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return ChallengeLeaderboardEntry(
      userId: json['userId'] as String? ?? '',
      athleteName: json['athleteName'] as String? ?? '',
      location: json['location'] as String?,
      progressValue: (json['progressValue'] as num?)?.toDouble() ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String summary;
  final String description;
  final ChallengeScope scope;
  final ChallengeMetric metric;
  final double targetValue;
  final List<String> qualifyingSportIds;
  final String organizingClubId;
  final String organizingClubName;
  final int organizingClubMembers;
  final DateTime startDate;
  final DateTime endDate;
  final String? bannerImageUrl;
  final ChallengeReward reward;
  final bool allowManualActivities;
  final bool publicOnlyLeaderboard;
  final int participantCount;
  final bool isJoined;
  final double userProgress;
  final List<String> invitedFriendIds;
  final List<ChallengeLeaderboardEntry> leaderboard;
  final DateTime createdAt;

  const Challenge({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.scope,
    required this.metric,
    required this.targetValue,
    required this.qualifyingSportIds,
    required this.organizingClubId,
    required this.organizingClubName,
    this.organizingClubMembers = 1,
    required this.startDate,
    required this.endDate,
    this.bannerImageUrl,
    required this.reward,
    this.allowManualActivities = false,
    this.publicOnlyLeaderboard = true,
    this.participantCount = 0,
    this.isJoined = false,
    this.userProgress = 0,
    this.invitedFriendIds = const [],
    this.leaderboard = const [],
    required this.createdAt,
  });

  List<ClubSport> get qualifyingSports =>
      [for (final sportId in qualifyingSportIds) ClubSport.byId(sportId)];

  double get completionRatio =>
      targetValue <= 0 ? 0 : (userProgress / targetValue).clamp(0, 1);

  bool get isCompleted => userProgress >= targetValue;

  Challenge copyWith({
    String? title,
    String? summary,
    String? description,
    int? participantCount,
    bool? isJoined,
    double? userProgress,
    List<String>? invitedFriendIds,
    List<ChallengeLeaderboardEntry>? leaderboard,
  }) {
    return Challenge(
      id: id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      scope: scope,
      metric: metric,
      targetValue: targetValue,
      qualifyingSportIds: qualifyingSportIds,
      organizingClubId: organizingClubId,
      organizingClubName: organizingClubName,
      organizingClubMembers: organizingClubMembers,
      startDate: startDate,
      endDate: endDate,
      bannerImageUrl: bannerImageUrl,
      reward: reward,
      allowManualActivities: allowManualActivities,
      publicOnlyLeaderboard: publicOnlyLeaderboard,
      participantCount: participantCount ?? this.participantCount,
      isJoined: isJoined ?? this.isJoined,
      userProgress: userProgress ?? this.userProgress,
      invitedFriendIds: invitedFriendIds ?? this.invitedFriendIds,
      leaderboard: leaderboard ?? this.leaderboard,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'description': description,
        'scope': scope.name,
        'metric': metric.name,
        'targetValue': targetValue,
        'qualifyingSportIds': qualifyingSportIds,
        'organizingClubId': organizingClubId,
        'organizingClubName': organizingClubName,
        'organizingClubMembers': organizingClubMembers,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'bannerImageUrl': bannerImageUrl,
        'reward': reward.toJson(),
        'allowManualActivities': allowManualActivities,
        'publicOnlyLeaderboard': publicOnlyLeaderboard,
        'participantCount': participantCount,
        'isJoined': isJoined,
        'userProgress': userProgress,
        'invitedFriendIds': invitedFriendIds,
        'leaderboard': [for (final entry in leaderboard) entry.toJson()],
        'createdAt': createdAt.toIso8601String(),
      };

  factory Challenge.fromJson(Map<String, dynamic> json) {
    final boardRaw = json['leaderboard'] as List? ?? const [];

    return Challenge(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      description: json['description'] as String? ?? '',
      scope: ChallengeScope.values.firstWhere(
        (s) => s.name == json['scope'],
        orElse: () => ChallengeScope.community,
      ),
      metric: ChallengeMetric.values.firstWhere(
        (m) => m.name == json['metric'],
        orElse: () => ChallengeMetric.distanceKm,
      ),
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 0,
      qualifyingSportIds:
          (json['qualifyingSportIds'] as List?)?.whereType<String>().toList() ??
              const ['all'],
      organizingClubId: json['organizingClubId'] as String? ?? '',
      organizingClubName: json['organizingClubName'] as String? ?? '',
      organizingClubMembers:
          (json['organizingClubMembers'] as num?)?.toInt() ?? 1,
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
          DateTime(2027, 1, 1),
      endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ??
          DateTime(2027, 1, 31),
      bannerImageUrl: json['bannerImageUrl'] as String?,
      reward: json['reward'] is Map<String, dynamic>
          ? ChallengeReward.fromJson(json['reward'] as Map<String, dynamic>)
          : const ChallengeReward(
              badgeCode: 'FINISHER',
              badgeTitle: 'Challenge Finisher',
              description: 'Completed the challenge target.',
            ),
      allowManualActivities: json['allowManualActivities'] as bool? ?? false,
      publicOnlyLeaderboard: json['publicOnlyLeaderboard'] as bool? ?? true,
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
      isJoined: json['isJoined'] as bool? ?? false,
      userProgress: (json['userProgress'] as num?)?.toDouble() ?? 0,
      invitedFriendIds:
          (json['invitedFriendIds'] as List?)?.whereType<String>().toList() ??
              const [],
      leaderboard: [
        for (final item in boardRaw)
          if (item is Map<String, dynamic>)
            ChallengeLeaderboardEntry.fromJson(item),
      ],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}