import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_overview/widgets/club_overview_sheets.dart';

class ClubSettingsPage extends ConsumerWidget {
  final Club club;

  const ClubSettingsPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => ClubSettingsPage(club: club)),
    );
  }

  Future<void> _update(WidgetRef ref, Club updated) {
    return ref.read(clubsProvider.notifier).updateClub(updated);
  }

  Future<void> _onReportClub(BuildContext context, Club current) async {
    final reason = await showReportClubSheet(context, current);
    if (reason == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report submitted. Thank you for keeping the community safe.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubs = ref.watch(clubsProvider).valueOrNull ?? const <Club>[];
    final current = clubs.firstWhere(
      (c) => c.id == club.id,
      orElse: () => club,
    );
    final settings = current.settings;
    final isInviteOnly = current.privacy.id == ClubPrivacy.private.id;

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Styles.textPrimary,
        title: const Text(
          'Club Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
        children: [
          if (current.canManage) ...[
            const _SettingsSectionHeader('Display Preferences'),
            _SettingsCard(
              children: [
                _SwitchSettingTile(
                  title: 'Show activity feed',
                  value: settings.showActivityFeed,
                  onChanged: (val) => _update(
                    ref,
                    current.copyWith(
                      settings: settings.copyWith(showActivityFeed: val),
                    ),
                  ),
                ),
                const _SettingDivider(),
                _SwitchSettingTile(
                  title: 'Show leaderboard and weekly stats',
                  subtitle: 'Include club leaderboard and enable stats tracking',
                  value: settings.showLeaderboardAndStats,
                  onChanged: (val) => _update(
                    ref,
                    current.copyWith(
                      settings: settings.copyWith(showLeaderboardAndStats: val),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SettingsSectionHeader('Permissions'),
            _SettingsCard(
              children: [
                _SwitchSettingTile(
                  title: 'Club is invite-only',
                  subtitle: 'New members require approval to join',
                  value: isInviteOnly,
                  onChanged: (val) => _update(
                    ref,
                    current.copyWith(
                      privacy: val ? ClubPrivacy.private : ClubPrivacy.public,
                    ),
                  ),
                ),
                const _SettingDivider(),
                _SwitchSettingTile(
                  title: 'Only admins can post',
                  subtitle: "Members can't post",
                  value: settings.onlyAdminsCanPost,
                  onChanged: (val) => _update(
                    ref,
                    current.copyWith(
                      settings: settings.copyWith(onlyAdminsCanPost: val),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
          ],
          const _SettingsSectionHeader('Notifications'),
          _SettingsCard(
            children: [
              _RadioSettingTile(
                title: 'All Posts',
                subtitle: 'Notify me for all posts in this club',
                selected:
                    settings.notifications == ClubNotificationPreference.allPosts,
                onTap: () => _update(
                  ref,
                  current.copyWith(
                    settings: settings.copyWith(
                      notifications: ClubNotificationPreference.allPosts,
                    ),
                  ),
                ),
              ),
              const _SettingDivider(),
              _RadioSettingTile(
                title: 'Announcements',
                subtitle: 'Only notify me of posts by club admins',
                selected: settings.notifications ==
                    ClubNotificationPreference.announcements,
                onTap: () => _update(
                  ref,
                  current.copyWith(
                    settings: settings.copyWith(
                      notifications: ClubNotificationPreference.announcements,
                    ),
                  ),
                ),
              ),
              const _SettingDivider(),
              _RadioSettingTile(
                title: 'Off',
                subtitle: "Don't notify me of any posts",
                selected:
                    settings.notifications == ClubNotificationPreference.off,
                onTap: () => _update(
                  ref,
                  current.copyWith(
                    settings: settings.copyWith(
                      notifications: ClubNotificationPreference.off,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _SettingsSectionHeader('Posts in Home Feed'),
          _SettingsCard(
            children: [
              _RadioSettingTile(
                title: 'All Posts',
                subtitle: 'Show all posts in this club in my feed',
                selected:
                    settings.homeFeedPosts == ClubHomeFeedPreference.allPosts,
                onTap: () => _update(
                  ref,
                  current.copyWith(
                    settings: settings.copyWith(
                      homeFeedPosts: ClubHomeFeedPreference.allPosts,
                    ),
                  ),
                ),
              ),
              const _SettingDivider(),
              _RadioSettingTile(
                title: 'Admin Posts',
                subtitle: 'Show only posts made by club admins in my feed',
                selected:
                    settings.homeFeedPosts == ClubHomeFeedPreference.adminPosts,
                onTap: () => _update(
                  ref,
                  current.copyWith(
                    settings: settings.copyWith(
                      homeFeedPosts: ClubHomeFeedPreference.adminPosts,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _SettingsSectionHeader('Community Standards'),
          _SettingsCard(
            children: [
              _NavigationSettingTile(
                title: "${AppBrand.name}'s community standards",
                onTap: () => showCommunityStandardsSheet(context),
              ),
              const _SettingDivider(),
              _NavigationSettingTile(
                title: 'Report Club',
                isDanger: true,
                onTap: () => _onReportClub(context, current),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;

  const _SettingsSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: Styles.primaryLight,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.cardDecoration(radius: Radii.card),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Styles.divider,
    );
  }
}

class _SwitchSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Styles.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Styles.textPrimary,
              activeTrackColor: Styles.primary,
              inactiveThumbColor: Styles.textMuted,
              inactiveTrackColor: Styles.surfaceElevated,
              trackOutlineColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.transparent
                    : Styles.borderStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioSettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RadioSettingTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Styles.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Styles.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Styles.primary : Styles.textMuted,
                  width: 2,
                ),
                boxShadow: selected
                    ? Styles.glow(intensity: 0.35, blur: 10)
                    : null,
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Styles.primaryLight,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationSettingTile extends StatelessWidget {
  final String title;
  final bool isDanger;
  final VoidCallback onTap;

  const _NavigationSettingTile({
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: isDanger ? Styles.danger : Styles.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDanger ? Styles.danger : Styles.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}