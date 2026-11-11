import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/club_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';

class ClubsTab extends StatelessWidget {
  final List<Club>? clubs;

  const ClubsTab({super.key, this.clubs});

  @override
  Widget build(BuildContext context) {
    final list = clubs ?? buildDummyClubs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchField(hintText: 'Find clubs...'),
        const _FilterRow(),
        Expanded(
          child: list.isEmpty
              ? const _EmptyState()
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final club = list[i];
                    return ClubTile(
                      club: club,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ClubDetailPage(club: club)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No clubs found',
        style: TextStyle(color: Styles.tabActive, fontSize: 18),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 12,
        children: [
          _FilterChip(icon: Icons.location_on_outlined, label: 'Location'),
          _FilterChip(label: 'Sport type'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  const _FilterChip({this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    return OutlinedButton.icon(
      onPressed: () {},
      icon: iconData == null ? const SizedBox.shrink() : Icon(iconData, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Styles.tabActive,
        shape: const StadiumBorder(),
        side: const BorderSide(color: Colors.white54),
      ),
    );
  }
}