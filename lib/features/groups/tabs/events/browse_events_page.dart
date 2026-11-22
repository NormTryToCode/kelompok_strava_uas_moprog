import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/event_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/event_filters_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/models/event_filter_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/event_sport_search_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';

class BrowseEventsPage extends ConsumerStatefulWidget {
  final EventFilter initialFilter;

  const BrowseEventsPage({
    super.key,
    this.initialFilter = const EventFilter(),
  });

  static Future<void> open(
    BuildContext context, {
    EventFilter initialFilter = const EventFilter(),
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => BrowseEventsPage(initialFilter: initialFilter),
      ),
    );
  }

  @override
  ConsumerState<BrowseEventsPage> createState() => _BrowseEventsPageState();
}

class _BrowseEventsPageState extends ConsumerState<BrowseEventsPage> {
  final _searchController = TextEditingController();
  late EventFilter _filter;
  String _sportQuery = '';

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickSport() async {
    final picked = await showEventSportSearchSheet(
      context,
      selected: _filter.sport,
    );
    if (picked == null || !mounted) return;

    setState(() {
      if (picked.id == ClubSport.allSports.id) {
        _filter = _filter.copyWith(clearSport: true);
      } else {
        _filter = _filter.copyWith(sport: picked);
      }
    });
  }

  Future<void> _openFilters() async {
    final updated = await EventFiltersPage.open(
      context,
      initialFilter: _filter,
    );
    if (updated == null || !mounted) return;
    setState(() => _filter = updated);
  }

  void _clearAll() {
    _searchController.clear();
    setState(() {
      _sportQuery = '';
      _filter = const EventFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final selectedSport = _filter.sport;
    final hasSport =
        selectedSport != null && selectedSport.id != ClubSport.allSports.id;
    final activeFilters = _filter.activeFilterCount;
    final hasAnyFilter = _filter.isFiltered || _sportQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Events',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Available Events',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _ToolbarPill(
                  icon: hasSport
                      ? selectedSport.icon
                      : Icons.layers_outlined,
                  label: hasSport ? selectedSport.name : 'Sport',
                  showDropdown: true,
                  active: hasSport,
                  onTap: _pickSport,
                ),
                const SizedBox(width: 8),
                _ToolbarPill(
                  icon: Icons.tune,
                  label: activeFilters > 0
                      ? 'Filters ($activeFilters)'
                      : 'Filters',
                  active: activeFilters > 0,
                  onTap: _openFilters,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _sportQuery = value),
              textInputAction: TextInputAction.search,
              cursorColor: Styles.accent,
              style: const TextStyle(fontSize: 14.5, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by sport (e.g. Cycling, Yoga, Surfing...)',
                hintStyle: const TextStyle(color: Styles.tabInactive),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Styles.tabInactive,
                  size: 20,
                ),
                suffixIcon: _sportQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _sportQuery = '');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Styles.tabInactive,
                          size: 18,
                        ),
                      ),
                filled: true,
                fillColor: Styles.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Palette.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: Styles.accent,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Styles.accent),
              ),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(eventsProvider),
                  style: TextButton.styleFrom(foregroundColor: Styles.accent),
                  child: const Text('Could not load events. Try again'),
                ),
              ),
              data: (allEvents) {
                final now = DateTime.now();
                final upcoming = allEvents
                    .where((e) => !e.startsAt.isBefore(now))
                    .toList();

                var visible = _filter.apply(upcoming, now: now);

                final needle = _sportQuery.trim().toLowerCase();
                if (needle.isNotEmpty) {
                  visible = visible.where((event) {
                    final sportName = event.sport?.name.toLowerCase() ?? '';
                    final subsports =
                        event.sport?.subsports?.toLowerCase() ?? '';
                    final eventName = event.name.toLowerCase();
                    return sportName.contains(needle) ||
                        subsports.contains(needle) ||
                        eventName.contains(needle);
                  }).toList();
                }

                visible.sort((a, b) => a.startsAt.compareTo(b.startsAt));

                if (visible.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const IconBubble(Icons.event_busy_outlined, size: 58),
                          const SizedBox(height: 14),
                          const Text(
                            'No matching events',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try another sport or adjust your filters.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Styles.tabInactive,
                            ),
                          ),
                          if (hasAnyFilter) ...[
                            const SizedBox(height: 14),
                            TextButton(
                              onPressed: _clearAll,
                              style: TextButton.styleFrom(
                                foregroundColor: Styles.accent,
                              ),
                              child: const Text(
                                'Clear filters',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    if (hasAnyFilter)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 12, 8),
                        child: Row(
                          children: [
                            Text(
                              '${visible.length} ${visible.length == 1 ? 'event' : 'events'} found',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Styles.tabInactive,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _clearAll,
                              style: TextButton.styleFrom(
                                foregroundColor: Styles.accent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Clear all',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final event = visible[index];
                          return ClubEventCard(
                            event: event,
                            displayDate: event.startsAt,
                            onTap: () => EventDetailPage.open(context, event),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showDropdown;
  final bool active;
  final VoidCallback onTap;

  const _ToolbarPill({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.showDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = active ? Styles.accent : Colors.white;

    return Material(
      color: active ? Styles.accent.withAlpha(24) : Styles.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: active ? Styles.accent : Palette.cardBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 96),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
              if (showDropdown) ...[
                const SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down, size: 17, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}