import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/race_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/race_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/race_showcase_card.dart';

class RacesPage extends ConsumerStatefulWidget {
  const RacesPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => const RacesPage()),
    );
  }

  @override
  ConsumerState<RacesPage> createState() => _RacesPageState();
}

class _RacesPageState extends ConsumerState<RacesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _sportId;
  RacePriceTier? _priceTier;
  RaceElevationProfile? _elevation;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRaces = ref.watch(racesProvider);
    final needle = _query.trim().toLowerCase();

    final filtered = allRaces.where((r) {
      if (_sportId != null && r.sport.id != _sportId) return false;
      if (_priceTier != null && r.priceTier != _priceTier) return false;
      if (_elevation != null && r.elevationProfile != _elevation) return false;
      if (needle.isNotEmpty) {
        final matchTitle = r.title.toLowerCase().contains(needle);
        final matchCity = r.locationLabel.toLowerCase().contains(needle);
        final matchTag = r.tags.any((t) => t.toLowerCase().contains(needle));
        if (!matchTitle && !matchCity && !matchTag) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Styles.textPrimary,
        title: const Text(
          'Races',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Styles.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search races, cities, or tags...',
                hintStyle: const TextStyle(color: Styles.textSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Styles.textSecondary,
                ),
                filled: true,
                fillColor: Styles.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Styles.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Styles.primary),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterPill(
                  label: 'All',
                  selected:
                      _sportId == null &&
                      _priceTier == null &&
                      _elevation == null,
                  onTap: () => setState(() {
                    _sportId = null;
                    _priceTier = null;
                    _elevation = null;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterPill(
                  label: 'Running',
                  selected: _sportId == 'running',
                  onTap: () => setState(
                    () => _sportId = _sportId == 'running' ? null : 'running',
                  ),
                ),
                const SizedBox(width: 8),
                _FilterPill(
                  label: 'Cycling',
                  selected: _sportId == 'cycling',
                  onTap: () => setState(
                    () => _sportId = _sportId == 'cycling' ? null : 'cycling',
                  ),
                ),
                const SizedBox(width: 8),
                _FilterPill(
                  label: 'Free',
                  selected: _priceTier == RacePriceTier.free,
                  onTap: () => setState(
                    () => _priceTier = _priceTier == RacePriceTier.free
                        ? null
                        : RacePriceTier.free,
                  ),
                ),
                const SizedBox(width: 8),
                _FilterPill(
                  label: 'Flat',
                  selected: _elevation == RaceElevationProfile.flat,
                  onTap: () => setState(
                    () => _elevation = _elevation == RaceElevationProfile.flat
                        ? null
                        : RaceElevationProfile.flat,
                  ),
                ),
                const SizedBox(width: 8),
                _FilterPill(
                  label: 'Mountain',
                  selected: _elevation == RaceElevationProfile.mountain,
                  onTap: () => setState(
                    () => _elevation =
                        _elevation == RaceElevationProfile.mountain
                        ? null
                        : RaceElevationProfile.mountain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching races found.',
                      style: TextStyle(color: Styles.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (_, index) => RaceShowcaseCard(
                      race: filtered[index],
                      onTap: () => RaceDetailPage.open(context, filtered[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Styles.surfaceHighlight : Styles.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? Styles.primary : Styles.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Styles.textPrimary : Styles.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}