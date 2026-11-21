import 'package:flutter/material.dart';

enum ChannelCategory {
  discussion(
    label: 'Discussion',
    icon: Icons.forum_outlined,
  ),
  announcement(
    label: 'Announcement',
    icon: Icons.campaign_outlined,
  ),
  routes(
    label: 'Routes & Pace',
    icon: Icons.alt_route,
  ),
  events(
    label: 'Events',
    icon: Icons.event_outlined,
  );

  final String label;
  final IconData icon;

  const ChannelCategory({
    required this.label,
    required this.icon,
  });
}

enum ChannelMembership {
  everyone(
    title: 'Everyone',
    subtitle: 'All club members join automatically.',
    icon: Icons.groups_outlined,
  ),
  optIn(
    title: 'Opt in',
    subtitle: 'Members choose to join this channel manually.',
    icon: Icons.person_add_alt_1_outlined,
  );

  final String title;
  final String subtitle;
  final IconData icon;

  const ChannelMembership({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

enum ChannelPostPermission {
  everyone(
    title: 'Everyone',
    subtitle: 'All members can send messages.',
    icon: Icons.chat_bubble_outline,
  ),
  adminsOnly(
    title: 'Admins only',
    subtitle: 'Only club admins can post updates.',
    icon: Icons.admin_panel_settings_outlined,
  );

  final String title;
  final String subtitle;
  final IconData icon;

  const ChannelPostPermission({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ChannelMessage {
  final String id;
  final String senderName;
  final String content;
  final DateTime sentAt;
  final bool isCurrentUser;

  const ChannelMessage({
    required this.id,
    required this.senderName,
    required this.content,
    required this.sentAt,
    this.isCurrentUser = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderName': senderName,
        'content': content,
        'sentAt': sentAt.toIso8601String(),
        'isCurrentUser': isCurrentUser,
      };

  factory ChannelMessage.fromJson(Map<String, dynamic> json) {
    return ChannelMessage(
      id: json['id'] as String? ?? '',
      senderName: json['senderName'] as String? ?? 'Member',
      content: json['content'] as String? ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] as String? ?? '') ??
          DateTime.now(),
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }
}

class ClubChannel {
  final String id;
  final String clubId;
  final String name;
  final String description;
  final ChannelCategory category;
  final ChannelMembership membership;
  final ChannelPostPermission postPermission;
  final bool isDefault;
  final int unreadCount;
  final DateTime createdAt;
  final List<ChannelMessage> messages;

  const ClubChannel({
    required this.id,
    required this.clubId,
    required this.name,
    required this.createdAt,
    this.description = '',
    this.category = ChannelCategory.discussion,
    this.membership = ChannelMembership.everyone,
    this.postPermission = ChannelPostPermission.everyone,
    this.isDefault = false,
    this.unreadCount = 0,
    this.messages = const [],
  });

  factory ClubChannel.defaultAnnouncements(String clubId) {
    return ClubChannel(
      id: 'announcements_$clubId',
      clubId: clubId,
      name: 'Announcements',
      description: 'Official updates and schedules from club admins.',
      category: ChannelCategory.announcement,
      membership: ChannelMembership.everyone,
      postPermission: ChannelPostPermission.adminsOnly,
      isDefault: true,
      createdAt: DateTime.now(),
    );
  }

  ChannelMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  ClubChannel copyWith({
    String? id,
    String? clubId,
    String? name,
    String? description,
    ChannelCategory? category,
    ChannelMembership? membership,
    ChannelPostPermission? postPermission,
    bool? isDefault,
    int? unreadCount,
    DateTime? createdAt,
    List<ChannelMessage>? messages,
  }) {
    return ClubChannel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      membership: membership ?? this.membership,
      postPermission: postPermission ?? this.postPermission,
      isDefault: isDefault ?? this.isDefault,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clubId': clubId,
        'name': name,
        'description': description,
        'category': category.name,
        'membership': membership.name,
        'postPermission': postPermission.name,
        'isDefault': isDefault,
        'unreadCount': unreadCount,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ClubChannel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];

    return ClubChannel(
      id: json['id'] as String? ?? '',
      clubId: json['clubId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: ChannelCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ChannelCategory.discussion,
      ),
      membership: ChannelMembership.values.firstWhere(
        (m) => m.name == json['membership'],
        orElse: () => ChannelMembership.everyone,
      ),
      postPermission: ChannelPostPermission.values.firstWhere(
        (p) => p.name == json['postPermission'],
        orElse: () => ChannelPostPermission.everyone,
      ),
      isDefault: json['isDefault'] as bool? ?? false,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
          messages: [
            if (rawMessages is List)
              for (final item in rawMessages)
                if (item is Map<String, dynamic>) ChannelMessage.fromJson(item),
      ],
    );
  }
}