import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/event_detail_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/count_pill.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final now = DateTime.now();

    return eventsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Palette.teal),
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
                style: TextButton.styleFrom(foregroundColor: Palette.teal),
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

        final past = allEvents.where((e) => e.startsAt.isBefore(now)).toList()
          ..sort((a, b) => b.startsAt.compareTo(a.startsAt));

        if (upcoming.isEmpty && past.isEmpty) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: const [_EmptyEventsCard()],
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            if (upcoming.isNotEmpty) ...[
              SectionTitle(
                'Upcoming events',
                trailing: CountPill(count: upcoming.length),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < upcoming.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ClubEventCard(
                  event: upcoming[i],
                  displayDate: upcoming[i].startsAt,
                  onTap: () => showEventDetailSheet(
                    context,
                    event: upcoming[i],
                    displayDate: upcoming[i].startsAt,
                    isPast: false,
                  ),
                ),
              ],
            ],
            if (upcoming.isNotEmpty && past.isNotEmpty)
              const SizedBox(height: 24),
            if (past.isNotEmpty) ...[
              SectionTitle(
                'Past events',
                trailing: CountPill(count: past.length),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < past.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ClubEventCard(
                  event: past[i],
                  displayDate: past[i].startsAt,
                  isPast: true,
                  onTap: () => showEventDetailSheet(
                    context,
                    event: past[i],
                    displayDate: past[i].startsAt,
                    isPast: true,
                  ),
                ),
              ],
            ],
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
            'Create an event from any club to see it here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Styles.tabInactive),
          ),
        ],
      ),
    );
  }
}