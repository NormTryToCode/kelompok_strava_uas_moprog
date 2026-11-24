import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/create_club_bar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/popular_club_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/your_club_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';

enum _ClubCategoryFilter { all, running, cycling, multisport }

class ClubsTab extends ConsumerStatefulWidget {
  const ClubsTab({super.key});

  @override
  ConsumerState<ClubsTab> createState() => _ClubsTabState();
}

class _ClubsTabState extends ConsumerState<ClubsTab> {
  _ClubCategoryFilter _filter = _ClubCategoryFilter.all;

  Future<void> _onCreateClub() async {
    final created = await ClubCreationPage.open(context);
    if (created == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.name} created')),
    );
  }

  Future<void> _onTapPopularJoin(Club club) async {
    if (club.isJoined) {
      await ClubDetailPage.open(context, club);
      return;
    }

    await ref.read(clubsProvider.notifier).joinClub(club.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Joined ${club.name}')),
    );
  }

  bool _matchesFilter(Club club) {
    switch (_filter) {
      case _ClubCategoryFilter.all:
        return true;
      case _ClubCategoryFilter.running:
        return club.sport.id == 'running' || club.sport.id == 'virtual-running';
      case _ClubCategoryFilter.cycling:
        return club.sport.id == 'cycling' || club.sport.id == 'e-biking';
      case _ClubCategoryFilter.multisport:
        return club.sport.id != 'running' &&
            club.sport.id != 'virtual-running' &&
            club.sport.id != 'cycling' &&
            club.sport.id != 'e-biking';
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubsAsync = ref.watch(clubsProvider);
    final allClubs = clubsAsync.valueOrNull ?? const <Club>[];

    final popularClubs = allClubs.where((c) => !c.isOwner).toList();
    final yourClubs =
        allClubs.where((c) => c.isJoined && _matchesFilter(c)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 28),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CreateClubBar(onCreate: _onCreateClub),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Popular near you',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SearchPage(initialTab: 1),
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Styles.primaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 17),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (clubsAsync.isLoading && !clubsAsync.hasValue)
          const SizedBox(
            height: 232,
            child: Center(
              child: CircularProgressIndicator(color: Styles.primary),
            ),
          )
        else
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: popularClubs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final club = popularClubs[index];
                return PopularClubCard(
                  club: club,
                  onTap: () => ClubDetailPage.open(context, club),
                  onJoinTap: () => _onTapPopularJoin(club),
                );
              },
            ),
          ),
        const SizedBox(height: 26),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your clubs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChipPill(
                label: 'All',
                selected: _filter == _ClubCategoryFilter.all,
                onTap: () => setState(() => _filter = _ClubCategoryFilter.all),
              ),
              const SizedBox(width: 8),
              _FilterChipPill(
                icon: Icons.directions_run,
                label: 'Running',
                selected: _filter == _ClubCategoryFilter.running,
                onTap: () =>
                    setState(() => _filter = _ClubCategoryFilter.running),
              ),
              const SizedBox(width: 8),
              _FilterChipPill(
                icon: Icons.directions_bike,
                label: 'Cycling',
                selected: _filter == _ClubCategoryFilter.cycling,
                onTap: () =>
                    setState(() => _filter = _ClubCategoryFilter.cycling),
              ),
              const SizedBox(width: 8),
              _FilterChipPill(
                label: 'Multisport',
                selected: _filter == _ClubCategoryFilter.multisport,
                onTap: () =>
                    setState(() => _filter = _ClubCategoryFilter.multisport),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: yourClubs.isEmpty
              ? _EmptyYourClubs(
                  isFiltered: _filter != _ClubCategoryFilter.all,
                  onResetFilter: () =>
                      setState(() => _filter = _ClubCategoryFilter.all),
                )
              : Container(
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < yourClubs.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            indent: 14,
                            endIndent: 14,
                            color: Styles.divider,
                          ),
                        YourClubTile(
                          seedId: yourClubs[i].id,
                          name: yourClubs[i].name,
                          initials: yourClubs[i].initials,
                          sportLabel: yourClubs[i].sport.name,
                          locationLabel: yourClubs[i].locationLabel,
                          memberLabel: yourClubs[i].memberLabel,
                          avatarPath: yourClubs[i].avatarPath,
                          onTap: () => ClubDetailPage.open(
                            context,
                            yourClubs[i],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _FilterChipPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Styles.surfaceHighlight : Styles.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? Styles.primary : Styles.border,
          width: selected ? 1.3 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 15,
                  color: selected ? Styles.primaryLight : Styles.textSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Styles.textPrimary : Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyYourClubs extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onResetFilter;

  const _EmptyYourClubs({
    required this.isFiltered,
    required this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: Styles.cardDecoration(radius: Radii.card),
      child: Column(
        children: [
          const Icon(
            Icons.groups_outlined,
            size: 40,
            color: Styles.primaryLight,
          ),
          const SizedBox(height: 12),
          Text(
            isFiltered ? 'No clubs in this category' : 'No clubs joined yet',
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isFiltered
                ? 'Try switching back to All to see your clubs.'
                : 'Create your own club above or join a popular one.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Styles.textSecondary,
            ),
          ),
          if (isFiltered) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: onResetFilter,
              style: TextButton.styleFrom(foregroundColor: Styles.primaryLight),
              child: const Text(
                'Show all clubs',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}