import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubEventCard extends StatelessWidget {
  final Event event;
  final DateTime displayDate;
  final bool isPast;
  final VoidCallback onTap;

  const ClubEventCard({
    super.key,
    required this.event,
    required this.displayDate,
    required this.onTap,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = formatTime(TimeOfDay.fromDateTime(displayDate));

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _CalendarDateBadge(date: displayDate, isPast: isPast),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (!isPast && event.isAttending) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Palette.teal.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Going',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Palette.teal,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      event.sport?.icon ?? event.kind.icon,
                      size: 14.5,
                      color: isPast ? Styles.tabInactive : Palette.teal,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${event.kind.name} \u00b7 ${event.placeLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      event.recurrence == null ? Icons.schedule : Icons.repeat,
                      size: 13.5,
                      color: Styles.tabInactive,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$timeLabel \u00b7 ${event.clubName} \u00b7 ${event.rsvpLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: Styles.tabInactive,
          ),
        ],
      ),
    );
  }
}

class _CalendarDateBadge extends StatelessWidget {
  final DateTime date;
  final bool isPast;

  const _CalendarDateBadge({
    required this.date,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isPast ? Styles.inactive : Palette.teal;
    final headerTextColor = isPast ? Styles.tabInactive : Styles.background;

    return Container(
      width: 58,
      decoration: BoxDecoration(
        color: Palette.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPast ? Palette.cardBorder : Palette.teal.withAlpha(110),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 3),
            color: headerColor,
            alignment: Alignment.center,
            child: Text(
              monthShort(date.month).toUpperCase(),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
                color: headerTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 5, 4, 6),
            child: Column(
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    color: isPast ? Styles.tabInactive : Colors.white,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  weekdayShort(date.weekday),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Styles.tabInactive,
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