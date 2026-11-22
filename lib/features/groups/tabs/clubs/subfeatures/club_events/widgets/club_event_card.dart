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

  Color get _kindColor {
    if (isPast) return Palette.textMuted;
    switch (event.kind.id) {
      case 'workout':
        return Palette.gold;
      case 'competition':
        return Palette.marigold;
      default:
        return Palette.aqua;
    }
  }

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
    final kindAccent = _kindColor;

    return Material(
      color: Palette.deepNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: !isPast && event.isAttending
              ? Palette.aqua.withAlpha(150)
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
              Container(width: 3.5, color: kindAccent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            event.sport?.icon ?? event.kind.icon,
                            size: 14,
                            color: kindAccent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${(event.sport?.name ?? event.kind.name).toUpperCase()} \u00b7 ${event.kind.name.toUpperCase()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: kindAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Palette.selectedFill,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _dateStamp,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Palette.textSecondary,
                              ),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                color: isPast
                                    ? Palette.textMuted
                                    : Palette.textPrimary,
                              ),
                            ),
                          ),
                          if (!isPast && event.isAttending) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: Palette.deepTeal.withAlpha(110),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Palette.aqua.withAlpha(150),
                                ),
                              ),
                              child: const Text(
                                'GOING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: Palette.aqua,
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
                            event.isVirtual
                                ? Icons.public
                                : Icons.place_outlined,
                            size: 14,
                            color: Palette.textMuted,
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
                                color: Palette.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Palette.cardBorder),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Palette.deepTeal.withAlpha(120),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Palette.deepTeal,
                              ),
                            ),
                            child: Text(
                              _clubInitial,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Palette.gold,
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
                                fontWeight: FontWeight.w500,
                                color: Palette.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.people_outline,
                            size: 14,
                            color: event.isAttending
                                ? Palette.aqua
                                : Palette.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _goingLabel,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: event.isAttending
                                  ? Palette.aqua
                                  : Palette.textPrimary,
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