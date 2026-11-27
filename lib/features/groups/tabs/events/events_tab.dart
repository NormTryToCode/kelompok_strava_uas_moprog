import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/browse_events_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/event_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/upcoming_event_hero_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/count_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/race_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/race_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/races_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/races_3d_carousel.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/race_model.dart';

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

  static const _localPreviewLimit = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final races = ref.watch(racesProvider).valueOrNull ?? const <Race>[];
    final now = DateTime.now();

    return eventsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Styles.primary),
      ),
      error: (_, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const IconBubble(Icons.error_outline, size: 54),
              const SizedBox(height: 12),
              const Text(
                'Could not load events.',
                style: TextStyle(fontSize: 15, color: Styles.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(eventsProvider),
                style: TextButton.styleFrom(
                  foregroundColor: Styles.primaryLight,
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (allEvents) {
        final upcoming =
            allEvents.where((e) => !e.startsAt.isBefore(now)).toList()
              ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

        final joinedUpcoming = upcoming.where((e) => e.isAttending).toList();
        final localPreview = upcoming.take(_localPreviewLimit).toList();
        final screenWidth = MediaQuery.of(context).size.width;

        return ListView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 28),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your upcoming events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                  if (joinedUpcoming.isNotEmpty)
                    CountPill(count: joinedUpcoming.length),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (joinedUpcoming.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _EmptyJoinedEventsCard(
                  onExplore: () => BrowseEventsPage.open(context),
                ),
              )
            else if (joinedUpcoming.length == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: UpcomingEventHeroCard(
                  event: joinedUpcoming.first,
                  onTap: () =>
                      EventDetailPage.open(context, joinedUpcoming.first),
                ),
              )
            else
              SizedBox(
                height: 264,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: joinedUpcoming.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final event = joinedUpcoming[index];
                    return UpcomingEventHeroCard(
                      width: (screenWidth - 52).clamp(270.0, 340.0),
                      event: event,
                      onTap: () => EventDetailPage.open(context, event),
                    );
                  },
                ),
              ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Local club events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => BrowseEventsPage.open(context),
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
            if (localPreview.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _EmptyLocalEventsCard(),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < localPreview.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      ClubEventCard(
                        event: localPreview[i],
                        displayDate: localPreview[i].startsAt,
                        onTap: () =>
                            EventDetailPage.open(context, localPreview[i]),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => BrowseEventsPage.open(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Styles.textPrimary,
                    backgroundColor: Styles.surface,
                    side: const BorderSide(color: Styles.borderStrong),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
                  ),
                  icon: const Icon(
                    Icons.explore_outlined,
                    size: 19,
                    color: Styles.primaryLight,
                  ),
                  label: Text(
                    upcoming.length > localPreview.length
                        ? 'Browse all ${upcoming.length} events'
                        : 'Browse Events',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            
            if (races.isNotEmpty) ...[
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Races',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => RacesPage.open(context),
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
              Races3DCarousel(
                races: races,
                onRaceTap: (race) => RaceDetailPage.open(context, race),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _EmptyJoinedEventsCard extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyJoinedEventsCard({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        highlighted: true,
        withGlow: true,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Styles.surfaceElevated.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Styles.primaryLight.withValues(alpha: 0.35),
              ),
            ),
            child: const Icon(
              Icons.event_available_outlined,
              color: Styles.primaryLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No events on your calendar',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'RSVP to a club session and see its route area here.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: Styles.buttonDecoration(
                      radius: Radii.chip,
                      withGlow: false,
                    ),
                    child: InkWell(
                      onTap: onExplore,
                      borderRadius: BorderRadius.circular(Radii.chip),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          'Explore events',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Styles.textPrimary,
                          ),
                        ),
                      ),
                    ),
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

class _EmptyLocalEventsCard extends StatelessWidget {
  const _EmptyLocalEventsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: Styles.cardDecoration(radius: Radii.card),
      child: const Column(
        children: [
          IconBubble(Icons.event_outlined, size: 54),
          SizedBox(height: 12),
          Text(
            'No upcoming club events',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Styles.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Create an event from any club to see it listed here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: Styles.textSecondary),
          ),
        ],
      ),
    );
  }
}