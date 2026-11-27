import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/user_profile.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

final _allRegisteredUsersProvider =
    FutureProvider.autoDispose<List<UserProfile>>((ref) {
      return UserRepository.instance.getAll();
    });

class ClubMembersPage extends ConsumerWidget {
  final Club club;

  const ClubMembersPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => ClubMembersPage(club: club)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(authStateProvider).valueOrNull?.uid;
    final clubs = ref.watch(clubsProvider).valueOrNull ?? const <Club>[];
    final current = clubs.firstWhere(
      (c) => c.id == club.id,
      orElse: () => club,
    );

    final registeredUsers =
        ref.watch(_allRegisteredUsersProvider).valueOrNull ??
        const <UserProfile>[];
    final peopleById = <String, Person>{
      for (final u in registeredUsers)
        u.uid: Person(
          id: u.uid,
          name: u.name.isNotEmpty ? u.name : '@${u.username}',
          location: '@${u.username}',
          tag: 'Athlete',
        ),
    };

    Person resolvePerson(String id) =>
        peopleById[id] ??
        Person(id: id, name: 'Athlete', location: 'Member', tag: 'Athlete');

    final members = [
      for (final id in current.memberIds)
        if (id != currentUid) resolvePerson(id),
    ];
    final pendingPeople = [
      for (final id in current.pendingRequestIds) resolvePerson(id),
    ];
    final admins = [
      for (final p in members)
        if (current.adminIds.contains(p.id)) p,
    ];

    final showPending =
        current.canManage && current.isPrivate && pendingPeople.isNotEmpty;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Styles.canvas,
        appBar: AppBar(
          backgroundColor: Styles.canvas,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Styles.textPrimary,
          title: const Text(
            'Club Members',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          bottom: const TabBar(
            indicatorColor: Styles.primary,
            indicatorWeight: 2.5,
            labelColor: Styles.textPrimary,
            unselectedLabelColor: Styles.textSecondary,
            labelStyle: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            tabs: [
              Tab(text: 'EVERYONE'),
              Tab(text: 'ADMINS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                if (showPending) ...[
                  const _ListSectionLabel('PENDING REQUESTS TO JOIN'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: Styles.cardDecoration(
                      radius: Radii.card,
                      borderColor: Styles.borderGlow.withValues(alpha: 0.4),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < pendingPeople.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              indent: 14,
                              endIndent: 14,
                              color: Styles.divider,
                            ),
                          _PendingRequestTile(
                            person: pendingPeople[i],
                            onDecline: () => ref
                                .read(clubsProvider.notifier)
                                .declineJoinRequest(
                                  current.id,
                                  pendingPeople[i].id,
                                ),
                            onAccept: () => ref
                                .read(clubsProvider.notifier)
                                .approveJoinRequest(
                                  current.id,
                                  pendingPeople[i].id,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                _ListSectionLabel('MEMBERS (${current.memberCount})'),
                const SizedBox(height: 10),
                Container(
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: Column(
                    children: [
                      if (current.isJoined) ...[
                        _MemberTile(
                          initials: 'Y',
                          name: 'You',
                          subtitle: current.locationLabel,
                          roleLabel: current.isOwner
                              ? 'OWNER'
                              : (current.isAdmin ? 'ADMIN' : null),
                        ),
                        if (members.isNotEmpty)
                          const Divider(
                            height: 1,
                            indent: 14,
                            endIndent: 14,
                            color: Styles.divider,
                          ),
                      ],
                      for (var i = 0; i < members.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            indent: 14,
                            endIndent: 14,
                            color: Styles.divider,
                          ),
                        _MemberTile(
                          initials: members[i].initials,
                          name: members[i].name,
                          subtitle: members[i].location,
                          roleLabel: current.adminIds.contains(members[i].id)
                              ? 'ADMIN'
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                const _ListSectionLabel('CLUB ADMINS'),
                const SizedBox(height: 10),
                Container(
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: Column(
                    children: [
                      if (current.canManage)
                        _MemberTile(
                          initials: 'Y',
                          name: 'You',
                          subtitle: current.locationLabel,
                          roleLabel: current.isOwner ? 'OWNER' : 'ADMIN',
                        ),
                      for (final admin in admins) ...[
                        const Divider(
                          height: 1,
                          indent: 14,
                          endIndent: 14,
                          color: Styles.divider,
                        ),
                        _MemberTile(
                          initials: admin.initials,
                          name: admin.name,
                          subtitle: admin.location,
                          roleLabel: 'ADMIN',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListSectionLabel extends StatelessWidget {
  final String text;

  const _ListSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: Styles.primaryLight,
        ),
      ),
    );
  }
}

class _PendingRequestTile extends StatelessWidget {
  final Person person;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  const _PendingRequestTile({
    required this.person,
    required this.onDecline,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: Styles.coverFor(person.id),
            ),
            child: Text(
              person.initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  person.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onDecline,
            style: TextButton.styleFrom(
              foregroundColor: Styles.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Decline',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
          FilledButton(
            onPressed: onAccept,
            style: FilledButton.styleFrom(
              backgroundColor: Styles.primary,
              foregroundColor: Styles.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Accept',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final String? roleLabel;

  const _MemberTile({
    required this.initials,
    required this.name,
    required this.subtitle,
    this.roleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Styles.surfaceElevated,
              border: Border.all(color: Styles.borderStrong),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Styles.primaryLight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                    if (roleLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Styles.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Styles.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          roleLabel!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Styles.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}