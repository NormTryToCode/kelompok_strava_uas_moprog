import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

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
    return '$text ${event.distanceUnit.label}';
  }

  String get _dateStamp {
    final day = weekdayShort(displayDate.weekday).toUpperCase();
    final month = monthShort(displayDate.month).toUpperCase();
    return '$day, ${displayDate.day} $month \u00b7 ${formatClock24(displayDate)}';
  }

  String get _goingLabel {
    if (event.attendeeCount <= 0) return 'Open RSVP';
    return '${event.attendeeCount} going';
  }

  String get _hostLabel {
    final members = event.clubMemberCount;
    if (members == null) return event.clubName;
    return '${event.clubName} \u00b7 ${members.withThousands}';
  }

  String get _clubInitial {
    final trimmed = event.clubName.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final accentGold = isPast ? Styles.tabInactive : Palette.teal;

    return Material(
      color: Styles.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: !isPast && event.isAttending
              ? Palette.teal.withAlpha(140)
              : Palette.cardBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3.5,
                color: isPast
                    ? Styles.inactive
                    : (event.isAttending ? Styles.accent : Palette.teal),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            event.sport?.icon ?? event.kind.icon,
                            size: 14,
                            color: accentGold,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${(event.sport?.name ?? event.kind.name).toUpperCase()} \u00b7 ${event.kind.name.toUpperCase()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                                color: accentGold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _dateStamp,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                color: isPast
                                    ? Styles.tabInactive
                                    : Colors.white,
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
                                color: Palette.selectedFill,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Palette.teal.withAlpha(130),
                                ),
                              ),
                              child: const Text(
                                'GOING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: Palette.teal,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            event.isVirtual
                                ? Icons.public
                                : Icons.place_outlined,
                            size: 14,
                            color: Styles.tabInactive,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              event.distance != null
                                  ? '${event.placeLabel} \u00b7 ${_formatDistance()}'
                                  : event.placeLabel,
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
                      const SizedBox(height: 11),
                      const Divider(height: 1, color: Palette.cardBorder),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Palette.selectedFill,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Palette.teal.withAlpha(110),
                              ),
                            ),
                            child: Text(
                              _clubInitial,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Palette.teal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              _hostLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Styles.tabInactive,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.people_outline,
                            size: 14,
                            color: accentGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _goingLabel,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}