import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';

enum ClubNotificationPreference {
  allPosts('all_posts'),
  announcements('announcements'),
  off('off');

  final String id;
  const ClubNotificationPreference(this.id);

  static ClubNotificationPreference byId(String? id) {
    return values.firstWhere(
      (e) => e.id == id,
      orElse: () => ClubNotificationPreference.allPosts,
    );
  }
}

enum ClubHomeFeedPreference {
  allPosts('all_posts'),
  adminPosts('admin_posts');

  final String id;
  const ClubHomeFeedPreference(this.id);

  static ClubHomeFeedPreference byId(String? id) {
    return values.firstWhere(
      (e) => e.id == id,
      orElse: () => ClubHomeFeedPreference.allPosts,
    );
  }
}

class ClubSettings {
  final bool showActivityFeed;
  final bool showLeaderboardAndStats;
  final bool onlyAdminsCanPost;
  final ClubNotificationPreference notifications;
  final ClubHomeFeedPreference homeFeedPosts;

  const ClubSettings({
    this.showActivityFeed = true,
    this.showLeaderboardAndStats = true,
    this.onlyAdminsCanPost = false,
    this.notifications = ClubNotificationPreference.allPosts,
    this.homeFeedPosts = ClubHomeFeedPreference.allPosts,
  });

  ClubSettings copyWith({
    bool? showActivityFeed,
    bool? showLeaderboardAndStats,
    bool? onlyAdminsCanPost,
    ClubNotificationPreference? notifications,
    ClubHomeFeedPreference? homeFeedPosts,
  }) {
    return ClubSettings(
      showActivityFeed: showActivityFeed ?? this.showActivityFeed,
      showLeaderboardAndStats:
          showLeaderboardAndStats ?? this.showLeaderboardAndStats,
      onlyAdminsCanPost: onlyAdminsCanPost ?? this.onlyAdminsCanPost,
      notifications: notifications ?? this.notifications,
      homeFeedPosts: homeFeedPosts ?? this.homeFeedPosts,
    );
  }

  Map<String, dynamic> toJson() => {
        'showActivityFeed': showActivityFeed,
        'showLeaderboardAndStats': showLeaderboardAndStats,
        'onlyAdminsCanPost': onlyAdminsCanPost,
        'notifications': notifications.id,
        'homeFeedPosts': homeFeedPosts.id,
      };

  factory ClubSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ClubSettings();
    return ClubSettings(
      showActivityFeed: json['showActivityFeed'] as bool? ?? true,
      showLeaderboardAndStats: json['showLeaderboardAndStats'] as bool? ?? true,
      onlyAdminsCanPost: json['onlyAdminsCanPost'] as bool? ?? false,
      notifications: ClubNotificationPreference.byId(
        json['notifications'] as String?,
      ),
      homeFeedPosts: ClubHomeFeedPreference.byId(
        json['homeFeedPosts'] as String?,
      ),
    );
  }
}

class Club {
  final String id;
  final String name;
  final String description;
  final ClubSport sport;
  final List<ClubType> types;
  final ClubPrivacy privacy;
  final bool isGlobal;
  final ClubLocation? location;
  final String? avatarPath;
  final String? coverPath;
  final String? vanityUrl;
  final int memberCount;
  final bool isOwner;
  final bool isAdmin;
  final bool isJoined;
  final List<String> memberIds;
  final List<String> adminIds;
  final ClubSettings settings;
  final DateTime createdAt;

  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.types,
    required this.privacy,
    required this.isGlobal,
    required this.location,
    required this.memberCount,
    required this.createdAt,
    this.isOwner = true,
    this.isAdmin = false,
    this.isJoined = true,
    this.memberIds = const [],
    this.adminIds = const [],
    this.settings = const ClubSettings(),
    this.avatarPath,
    this.coverPath,
    this.vanityUrl,
  });

  factory Club.fromCreation(ClubCreationModel draft) {
    final now = DateTime.now();
    return Club(
      id: now.microsecondsSinceEpoch.toString(),
      name: draft.name.trim(),
      description: draft.description.trim(),
      sport: draft.sport,
      types: draft.types,
      privacy: draft.privacy,
      isGlobal: draft.isGlobal,
      location: draft.isGlobal ? null : draft.location,
      avatarPath: draft.avatarPath,
      memberCount: 1,
      isOwner: true,
      isAdmin: true,
      isJoined: true,
      createdAt: now,
    );
  }

  bool get canManage => isOwner || isAdmin;

  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  String get memberLabel {
    if (memberCount >= 1000000) {
      return '${(memberCount / 1000000).toStringAsFixed(1)}M Members';
    }
    if (memberCount >= 1000) {
      return '${(memberCount / 1000).toStringAsFixed(1)}K Members';
    }
    return memberCount == 1 ? '1 Member' : '$memberCount Members';
  }

  String get typeLabel => types.map((t) => t.name).join(' \u00b7 ');

  String get locationLabel => isGlobal || location == null
      ? 'Global'
      : location!.detail.isEmpty
          ? location!.name
          : '${location!.name}, ${location!.detail}';

  Club copyWith({
    String? id,
    String? name,
    String? description,
    ClubSport? sport,
    List<ClubType>? types,
    ClubPrivacy? privacy,
    bool? isGlobal,
    ClubLocation? location,
    bool clearLocation = false,
    String? avatarPath,
    bool clearAvatar = false,
    String? coverPath,
    bool clearCover = false,
    String? vanityUrl,
    bool clearVanityUrl = false,
    int? memberCount,
    bool? isOwner,
    bool? isAdmin,
    bool? isJoined,
    List<String>? memberIds,
    List<String>? adminIds,
    ClubSettings? settings,
    DateTime? createdAt,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sport: sport ?? this.sport,
      types: types ?? this.types,
      privacy: privacy ?? this.privacy,
      isGlobal: isGlobal ?? this.isGlobal,
      location: clearLocation ? null : (location ?? this.location),
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      coverPath: clearCover ? null : (coverPath ?? this.coverPath),
      vanityUrl: clearVanityUrl ? null : (vanityUrl ?? this.vanityUrl),
      memberCount: memberCount ?? this.memberCount,
      isOwner: isOwner ?? this.isOwner,
      isAdmin: isAdmin ?? this.isAdmin,
      isJoined: isJoined ?? this.isJoined,
      memberIds: memberIds ?? this.memberIds,
      adminIds: adminIds ?? this.adminIds,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final place = location;
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport.id,
      'types': types.map((t) => t.id).toList(),
      'privacy': privacy.id,
      'isGlobal': isGlobal,
      'location': place == null
          ? null
          : {
              'name': place.name,
              'detail': place.detail,
              'latitude': place.latitude,
              'longitude': place.longitude,
            },
      'avatarPath': avatarPath,
      'coverPath': coverPath,
      'vanityUrl': vanityUrl,
      'memberCount': memberCount,
      'isOwner': isOwner,
      'isAdmin': isAdmin,
      'isJoined': isJoined,
      'memberIds': memberIds,
      'adminIds': adminIds,
      'settings': settings.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Club.fromJson(Map<String, dynamic> json) {
    final typeIds =
        (json['types'] as List?)?.whereType<String>().toSet() ?? <String>{};
    final place = json['location'];
    final isOwner = json['isOwner'] as bool? ?? true;

    return Club(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sport: ClubSport.option.firstWhere(
        (s) => s.id == json['sport'],
        orElse: () => ClubSport.allSports,
      ),
      types: ClubType.option.where((t) => typeIds.contains(t.id)).toList(),
      privacy: ClubPrivacy.option.firstWhere(
        (p) => p.id == json['privacy'],
        orElse: () => ClubPrivacy.public,
      ),
      isGlobal: json['isGlobal'] as bool? ?? true,
      location: place is Map
          ? ClubLocation(
              name: place['name'] as String? ?? '',
              detail: place['detail'] as String? ?? '',
              latitude: (place['latitude'] as num?)?.toDouble(),
              longitude: (place['longitude'] as num?)?.toDouble(),
            )
          : null,
      avatarPath: json['avatarPath'] as String?,
      coverPath: json['coverPath'] as String?,
      vanityUrl: json['vanityUrl'] as String?,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
      isOwner: isOwner,
      isAdmin: json['isAdmin'] as bool? ?? isOwner,
      isJoined: json['isJoined'] as bool? ?? true,
      memberIds:
          (json['memberIds'] as List?)?.whereType<String>().toList() ?? const [],
      adminIds:
          (json['adminIds'] as List?)?.whereType<String>().toList() ?? const [],
      settings: ClubSettings.fromJson(
        json['settings'] is Map
            ? Map<String, dynamic>.from(json['settings'] as Map)
            : null,
      ),
      createdAt: json['createdAt'] is String
          ? (DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}