import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/club_event_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_events/widgets/event_detail_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubEventsSection extends ConsumerWidget {
  final String clubId;
  final VoidCallback onCreateEvent;
  final VoidCallback onViewAll;

  const ClubEventsSection({
    super.key,
    required this.clubId,
    required this.onCreateEvent,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final now = DateTime.now();

    final upcoming =
        (eventsAsync.valueOrNull ?? [])
            .where((e) => e.clubId == clubId && !e.startsAt.isBefore(now))
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    final preview = upcoming.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Upcoming events',
          trailing: TextButton.icon(
            onPressed: onCreateEvent,
            style: TextButton.styleFrom(
              foregroundColor: Styles.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Create event',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (eventsAsync.isLoading && !eventsAsync.hasValue)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(color: Styles.teal)),
          )
        else if (preview.isEmpty)
          SoftCard(
            onTap: onCreateEvent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: const SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  IconBubble(Icons.event_outlined, size: 54),
                  SizedBox(height: 12),
                  Text(
                    'Nothing scheduled yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plan a ride, run, or workout for your members.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Styles.surfaceHighlight,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < preview.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ClubEventCard(
                  event: preview[i],
                  displayDate: preview[i].startsAt,
                  onTap: () => showEventDetailSheet(
                    context,
                    event: preview[i],
                    displayDate: preview[i].startsAt,
                    isPast: false,
                  ),
                ),
              ],
              if (upcoming.length > preview.length) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(foregroundColor: Styles.teal),
                    child: Text(
                      'See all ${upcoming.length} upcoming events',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

