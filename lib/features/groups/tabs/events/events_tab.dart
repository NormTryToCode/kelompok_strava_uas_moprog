import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/browse_events_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/event_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/count_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

  static const _previewLimit = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final now = DateTime.now();

    return eventsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Styles.accent),
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
                style: TextStyle(fontSize: 15, color: Styles.tabInactive),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(eventsProvider),
                style: TextButton.styleFrom(foregroundColor: Styles.accent),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (allEvents) {
        final upcoming = allEvents
            .where((e) => !e.startsAt.isBefore(now))
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

        final preview = upcoming.take(_previewLimit).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            SectionTitle(
              'Upcoming events',
              trailing:
                  upcoming.isEmpty ? null : CountPill(count: upcoming.length),
            ),
            const SizedBox(height: 12),
            if (preview.isEmpty)
              const _EmptyEventsCard()
            else
              for (var i = 0; i < preview.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ClubEventCard(
                  event: preview[i],
                  displayDate: preview[i].startsAt,
                  onTap: () => EventDetailPage.open(context, preview[i]),
                ),
              ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => BrowseEventsPage.open(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Styles.accent,
                  side: BorderSide(color: Styles.accent.withAlpha(160)),
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.explore_outlined, size: 20),
                label: Text(
                  upcoming.length > preview.length
                      ? 'Browse all ${upcoming.length} events'
                      : 'Browse Events',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyEventsCard extends StatelessWidget {
  const _EmptyEventsCard();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          IconBubble(Icons.event_outlined, size: 56),
          SizedBox(height: 14),
          Text(
            'No events yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Create an event from any club or browse upcoming events.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Styles.tabInactive),
          ),
        ],
      ),
    );
  }
}