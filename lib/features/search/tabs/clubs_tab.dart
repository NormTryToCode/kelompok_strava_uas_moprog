import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club_filter.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/club_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/filter_option_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/filter_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';

class ClubsTab extends StatefulWidget {
  final List<Club>? clubs;

  const ClubsTab({super.key, this.clubs});

  @override
  State<ClubsTab> createState() => _ClubsTabState();
}

class _ClubsTabState extends State<ClubsTab> {
  final TextEditingController _searchController = TextEditingController();
  late final List<Club> _allClubs = widget.clubs ?? buildDummyClubs();
  ClubFilter _filter = const ClubFilter();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pickCity() {
    showFilterSheet<String>(
      context: context,
      title: 'Location',
      allLabel: 'All locations',
      options: citiesOf(_allClubs),
      labelOf: (city) => city,
      selected: _filter.city,
      onSelected: (city) => setState(() => _filter = _filter.withCity(city)),
    );
  }

  void _pickSport() {
    showFilterSheet<SportType>(
      context: context,
      title: 'Sport type',
      allLabel: 'All sports',
      options: SportType.values,
      labelOf: (sport) => sport.label,
      selected: _filter.sport,
      onSelected: (sport) =>
          setState(() => _filter = _filter.withSport(sport)),
    );
  }

  void _openDetail(Club club) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ClubDetailPage(club: club)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter.apply(_allClubs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchField(
          hintText: 'Find clubs...',
          controller: _searchController,
          onChanged: (value) =>
              setState(() => _filter = _filter.withQuery(value)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 12,
            children: [
              FilterPill(
                label: _filter.city ?? 'Location',
                icon: Icons.location_on_outlined,
                isActive: _filter.city != null,
                onTap: _pickCity,
              ),
              FilterPill(
                label: _filter.sport?.label ?? 'Sport type',
                isActive: _filter.sport != null,
                onTap: _pickSport,
              ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const _EmptyState()
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, i) {
                    final club = visible[i];
                    return ClubTile(
                      club: club,
                      onTap: () => _openDetail(club),
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