import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/calendar_date_badge.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class EventCardItem extends StatelessWidget {
  final Event event;
  final DateTime date;
  final VoidCallback onTap;

  const EventCardItem({
    super.key,
    required this.event,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = formatTime(TimeOfDay.fromDateTime(date));

    return Material(
      color: Styles.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CalendarDateBadge(date: date),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          event.sport?.icon ?? Icons.event_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${event.kind.name} \u00b7 ${event.clubName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          event.recurrence == null
                              ? Icons.schedule
                              : Icons.repeat,
                          size: 16,
                          color: Styles.tabInactive,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$time \u00b7 ${event.attendeeLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Styles.tabInactive),
            ],
          ),
        ),
      ),
    );
  }
}
