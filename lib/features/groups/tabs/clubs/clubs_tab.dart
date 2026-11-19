import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/create_club_bar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubsTab extends StatefulWidget {
  const ClubsTab({super.key});

  @override
  State<ClubsTab> createState() => _ClubsTabState();
}

class _ClubsTabState extends State<ClubsTab> {
  List<Club> _clubs = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    List<Club> clubs;
    try {
      clubs = await ClubRepository.instance.getClubs();
    } catch (_) {
      clubs = const [];
    }
    if (!mounted) return;
    setState(() {
      _clubs = clubs;
      _loading = false;
    });
  }

  Future<void> _onCreateClub() async {
    final created = await ClubCreationPage.open(context);
    if (created == null || !mounted) return;

    setState(() => _clubs = [created, ..._clubs]);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.name} created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: CreateClubBar(onCreate: _onCreateClub),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              'Your clubs',
              trailing: _clubs.isEmpty ? null : _CountPill(count: _clubs.length),
            ),
          ),
        ),
        if (!_loading && _clubs.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverToBoxAdapter(child: _EmptyClubs()),
          ),
        if (_clubs.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 196,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ClubCardItem(
                  club: _clubs[index],
                  onTap: () => ClubDetailPage.open(context, _clubs[index]),
                ),
                childCount: _clubs.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;

  const _CountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Palette.teal.withAlpha(34),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Palette.teal,
        ),
      ),
    );
  }
}

class _EmptyClubs extends StatelessWidget {
  const _EmptyClubs();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          IconBubble(Icons.flag_outlined, size: 56),
          SizedBox(height: 14),
          Text(
            'No clubs yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Create one to start organizing events.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Styles.tabInactive),
          ),
        ],
      ),
    );
  }
}
