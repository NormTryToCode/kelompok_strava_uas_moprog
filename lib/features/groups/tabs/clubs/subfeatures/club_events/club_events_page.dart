import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/event_detail_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_creation_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';

enum _EventFilter { upcoming, past }

class ClubEventsPage extends ConsumerStatefulWidget {
  final Club club;

  const ClubEventsPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => ClubEventsPage(club: club)));
  }

  @override
  ConsumerState<ClubEventsPage> createState() => _ClubEventsPageState();
}

class _ClubEventsPageState extends ConsumerState<ClubEventsPage> {
  _EventFilter _filter = _EventFilter.upcoming;

  Future<void> _onCreateEvent() async {
    final created = await EventCreationPage.open(context, widget.club);
    if (created == null || !mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${created.name} created')));
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              widget.club.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Styles.surfaceHighlight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _onCreateEvent,
            icon: const Icon(Icons.add, size: 28),
            tooltip: 'Create an event',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _EventsFilterToggle(
              selected: _filter,
              onChanged: (value) => setState(() => _filter = value),
            ),
          ),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Styles.teal),
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
                        style: TextStyle(
                          fontSize: 15,
                          color: Styles.surfaceHighlight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(eventsProvider),
                        style: TextButton.styleFrom(
                          foregroundColor: Styles.teal,
                        ),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (allEvents) {
                final clubEvents = allEvents
                    .where((e) => e.clubId == widget.club.id)
                    .toList();

                final isPast = _filter == _EventFilter.past;
                final filtered =
                    clubEvents
                        .where(
                          (e) => isPast
                              ? e.startsAt.isBefore(now)
                              : !e.startsAt.isBefore(now),
                        )
                        .toList()
                      ..sort(
                        (a, b) => isPast
                            ? b.startsAt.compareTo(a.startsAt)
                            : a.startsAt.compareTo(b.startsAt),
                      );

                if (filtered.isEmpty) {
                  return _EmptyEventsView(
                    isPast: isPast,
                    onCreateEvent: _onCreateEvent,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final event = filtered[index];
                    return ClubEventCard(
                      event: event,
                      displayDate: event.startsAt,
                      isPast: isPast,
                      onTap: () => showEventDetailSheet(
                        context,
                        event: event,
                        displayDate: event.startsAt,
                        isPast: isPast,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsFilterToggle extends StatelessWidget {
  final _EventFilter selected;
  final ValueChanged<_EventFilter> onChanged;

  const _EventsFilterToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(Radii.button),
        border: Border.all(color: Styles.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: 'Upcoming',
              selected: selected == _EventFilter.upcoming,
              onTap: () => onChanged(_EventFilter.upcoming),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: 'Past',
              selected: selected == _EventFilter.past,
              onTap: () => onChanged(_EventFilter.past),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Styles.selectedFill : Colors.transparent,
      borderRadius: BorderRadius.circular(Radii.button - 3),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.button - 3),
                  border: Border.all(color: Styles.teal.withAlpha(130)),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 16, color: Styles.teal),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : Styles.surfaceHighlight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyEventsView extends StatelessWidget {
  final bool isPast;
  final VoidCallback onCreateEvent;

  const _EmptyEventsView({required this.isPast, required this.onCreateEvent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBubble(
              isPast ? Icons.history_rounded : Icons.event_available_outlined,
              size: 64,
            ),
            const SizedBox(height: 18),
            Text(
              isPast ? 'No past events yet.' : 'No upcoming events right now.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPast
                  ? 'Completed club events will be archived here.'
                  : 'New ones will appear here once they\'re scheduled.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: Styles.surfaceHighlight,
              ),
            ),
            if (!isPast) ...[
              const SizedBox(height: 22),
              SizedBox(
                width: 210,
                child: PrimaryButton(
                  label: 'Create an event',
                  onPressed: onCreateEvent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

