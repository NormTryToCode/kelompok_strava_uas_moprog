import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
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

  String _formatDistance() {
    final d = event.distance!;
    final text = d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
    return '$text${event.distanceUnit.label}';
  }

  String get _metaLine {
    final parts = <String>[
      if (event.distance != null) _formatDistance(),
      event.kind.name,
      event.placeLabel,
    ];
    return parts.join(' \u00b7 ');
  }

  String get _goingLine {
    if (event.attendeeCount <= 0) return "Don't forget to RSVP";
    if (event.attendeeCount == 1) return '1 is going';
    return '${event.attendeeCount} are going';
  }

  String get _hostLine {
    final members = event.clubMemberCount;
    if (members == null) return event.clubName;
    return '${event.clubName} \u00b7 ${members.withThousands} members';
  }

  String get _clubInitial {
    final trimmed = event.clubName.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 16,
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
                          fontSize: 16,
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
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Styles.accent.withAlpha(32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Going',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Styles.accent,
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
                      color: Styles.tabInactive,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _metaLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 14.5,
                      color: Styles.tabInactive,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _goingLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Styles.accent.withAlpha(34),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _clubInitial,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Styles.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _hostLine,
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
    final headerColor = isPast ? Styles.inactive : Styles.accent;

    return Container(
      width: 56,
      decoration: BoxDecoration(
        color: Palette.fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.cardBorder),
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
              monthShort(date.month),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isPast ? Styles.tabInactive : Colors.white,
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