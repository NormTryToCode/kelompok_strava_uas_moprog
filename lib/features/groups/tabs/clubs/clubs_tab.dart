import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/create_club_bar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubsTab extends ConsumerWidget {
  const ClubsTab({super.key});

  Future<void> _onCreateClub(BuildContext context) async {
    final created = await ClubCreationPage.open(context);
    if (created == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.name} created')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(clubsProvider);
    final clubs = clubsAsync.valueOrNull ?? const <Club>[];
    final loading = clubsAsync.isLoading && !clubsAsync.hasValue;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: CreateClubBar(onCreate: () => _onCreateClub(context)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverToBoxAdapter(
            child: SectionTitle(
              'Your clubs',
              trailing: clubs.isEmpty ? null : _CountPill(count: clubs.length),
            ),
          ),
        ),
        if (!loading && clubs.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverToBoxAdapter(child: _EmptyClubs()),
          ),
        if (clubs.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 204,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ClubCardItem(
                  club: clubs[index],
                  onTap: () => ClubDetailPage.open(context, clubs[index]),
                ),
                childCount: clubs.length,
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