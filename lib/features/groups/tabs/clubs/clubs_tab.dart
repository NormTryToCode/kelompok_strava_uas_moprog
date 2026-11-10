import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/club_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/create_club_bar.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreateClubBar(onCreate: _onCreateClub),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    if (_loading) return const SizedBox.shrink();

    if (_clubs.isEmpty) {
      return const Center(
        child: Text(
          'No clubs yet',
          style: TextStyle(fontSize: 16, color: Styles.tabInactive),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _clubs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ClubCardItem(
        club: _clubs[i],
        onTap: () => ClubDetailPage.open(context, _clubs[i]),
      ),
    );
  }
}
