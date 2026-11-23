import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/int_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/event_map_preview.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/confirm_delete_dialog.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailPage extends ConsumerWidget {
  final Event initialEvent;

  const EventDetailPage({super.key, required this.initialEvent});

  static Future<void> open(BuildContext context, Event event) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => EventDetailPage(initialEvent: event),
      ),
    );
  }

  Color _kindColor(EventKind kind) {
    switch (kind.id) {
      case 'workout':
        return Styles.gold;
      case 'competition':
        return Styles.marigold;
      default:
        return Styles.aqua;
    }
  }

  List<Person> _resolveParticipants(Event event) {
    final allPeople = buildDummyPeople();
    final byId = {for (final p in allPeople) p.id: p};
    return [
      for (final id in event.participantIds)
        if (byId[id] != null) byId[id]!,
    ];
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDistance(Event event) {
    final d = event.distance;
    if (d == null) return 'Open';
    final text = d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
    return '$text ${event.distanceUnit.label}';
  }

  Future<void> _shareEvent(Event event) async {
    final date =
        '${formatDate(event.startsAt)} at ${formatClock24(event.startsAt)}';
    final text = [
      '${event.name} (${event.sport?.name ?? event.kind.name})',
      '$date \u00b7 ${event.placeLabel}',
      'Hosted by ${event.clubName}',
    ].join('\n');

    await SharePlus.instance.share(
      ShareParams(text: text, subject: event.name),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Delete event?',
      message: '"${event.name}" will be removed from the schedule.',
    );
    if (!confirmed || !context.mounted) return;

    await ref.read(eventsProvider.notifier).deleteEvent(event.id);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${event.name} deleted')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider).valueOrNull ?? const <Event>[];
    final event = events.firstWhere(
      (e) => e.id == initialEvent.id,
      orElse: () => initialEvent,
    );

    final isPast = event.startsAt.isBefore(DateTime.now());
    final lat = event.location?.latitude;
    final lng = event.location?.longitude;
    final hasCoords = !event.isVirtual && lat != null && lng != null;
    final participants = _resolveParticipants(event);
    final kindColor = _kindColor(event.kind);

    final fullSchedule =
        '${weekdayName(event.startsAt.weekday)}, ${formatDate(event.startsAt)} \u00b7 ${formatClock24(event.startsAt)}';

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Styles.textPrimary,
        title: const Text(
          'Event Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Styles.deepNavy,
            icon: const Icon(Icons.more_horiz, color: Styles.textPrimary),
            onSelected: (value) {
              if (value == 'share') {
                _shareEvent(event);
              } else if (value == 'delete') {
                _confirmDelete(context, ref, event);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'share',
                child: Text(
                  'Share event',
                  style: TextStyle(color: Styles.textPrimary),
                ),
              ),
              if (!event.id.startsWith('seed_event_'))
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete event',
                    style: TextStyle(color: Styles.accent),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Styles.deepNavy,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.deepTeal),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Styles.selectedFill,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Styles.aqua.withAlpha(110),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  event.sport?.icon ?? event.kind.icon,
                                  size: 14,
                                  color: Styles.aqua,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  (event.sport?.name ?? 'Open Sport')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                    color: Styles.aqua,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: kindColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: kindColor.withAlpha(120),
                              ),
                            ),
                            child: Text(
                              event.kind.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: kindColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 16,
                            color: Styles.gold,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              fullSchedule,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (event.recurrence != null) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 23),
                          child: Text(
                            event.recurrence!.summary(event.startsAt),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Styles.cardBorder),
                      const SizedBox(height: 14),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _MetricCell(
                                label: 'DISTANCE',
                                value: _formatDistance(event),
                                valueColor: Styles.textPrimary,
                              ),
                            ),
                            const VerticalDivider(
                              width: 1,
                              color: Styles.cardBorder,
                            ),
                            Expanded(
                              child: _MetricCell(
                                label: 'SURFACE',
                                value:
                                    event.surface?.name ??
                                    (event.isVirtual ? 'Virtual' : 'Mixed'),
                                valueColor: Styles.aqua,
                              ),
                            ),
                            const VerticalDivider(
                              width: 1,
                              color: Styles.cardBorder,
                            ),
                            Expanded(
                              child: _MetricCell(
                                label: 'GOING',
                                value: '${event.attendeeCount}',
                                valueColor: Styles.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '"${event.name}" added to your calendar',
                                  ),
                                ),
                              );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.textPrimary,
                            backgroundColor: Styles.selectedFill,
                            side: const BorderSide(color: Styles.deepTeal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                            size: 17,
                            color: Styles.aqua,
                          ),
                          label: const Text(
                            'Add to Calendar',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  const _SectionLabel('ABOUT THIS EVENT'),
                  const SizedBox(height: 8),
                  SoftCard(
                    color: Styles.deepNavy,
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 22),
                const _SectionLabel('LOCATION'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Styles.deepNavy,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Styles.cardBorder),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasCoords)
                        EventMapPreview(
                          latitude: lat,
                          longitude: lng,
                          height: 196,
                          zoom: 15,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: event.isVirtual
                                    ? Styles.selectedFill
                                    : Styles.marigold.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      (event.isVirtual
                                              ? Styles.aqua
                                              : Styles.marigold)
                                          .withAlpha(120),
                                ),
                              ),
                              child: Icon(
                                event.isVirtual
                                    ? Icons.public
                                    : Icons.location_on_outlined,
                                size: 20,
                                color: event.isVirtual
                                    ? Styles.aqua
                                    : Styles.marigold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.placeLabel,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Styles.textPrimary,
                                    ),
                                  ),
                                  if (!event.isVirtual &&
                                      (event.location?.detail.isNotEmpty ??
                                          false)) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      event.location!.detail,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Styles.textSecondary,
                                      ),
                                    ),
                                  ] else if (event.isVirtual) ...[
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Join from anywhere online',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Styles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                const _SectionLabel('HOSTED BY'),
                const SizedBox(height: 8),
                SoftCard(
                  color: Styles.deepNavy,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Styles.deepTeal.withAlpha(130),
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(color: Styles.deepTeal),
                            ),
                            child: Text(
                              _initials(event.clubName),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Styles.gold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.clubName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                if (event.clubMemberCount != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '${event.clubMemberCount!.withThousands} Athletes',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Styles.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (event.clubDescription != null &&
                          event.clubDescription!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          event.clubDescription!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ],
                      if (event.organizerName != null &&
                          event.organizerName!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Styles.cardBorder),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Styles.fieldFill,
                                border: Border.all(color: Styles.cardBorder),
                              ),
                              child: Text(
                                _initials(event.organizerName!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Styles.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                event.organizerName!,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Styles.textPrimary,
                                ),
                              ),
                            ),
                            const Text(
                              'ORGANIZER',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                                color: Styles.gold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                _SectionLabel('ATTENDEES (${event.attendeeCount})'),
                const SizedBox(height: 8),
                SoftCard(
                  color: Styles.deepNavy,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      if (event.isAttending)
                        const _ParticipantRow(
                          initials: 'Y',
                          name: 'You',
                          subtitle: 'Confirmed going',
                          highlight: true,
                        ),
                      for (var i = 0; i < participants.length; i++) ...[
                        if (i > 0 || event.isAttending)
                          const Divider(height: 18, color: Styles.cardBorder),
                        _ParticipantRow(
                          initials: participants[i].initials,
                          name: participants[i].name,
                          subtitle: participants[i].location,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Styles.canvas,
              border: Border(top: BorderSide(color: Styles.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    if (!isPast) ...[
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 48,
                          child: event.isAttending
                              ? OutlinedButton.icon(
                                  onPressed: () => ref
                                      .read(eventsProvider.notifier)
                                      .toggleRsvp(event.id),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Styles.aqua,
                                    backgroundColor: Styles.selectedFill,
                                    side: const BorderSide(color: Styles.aqua),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text(
                                    'Going',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : FilledButton(
                                  onPressed: () => ref
                                      .read(eventsProvider.notifier)
                                      .toggleRsvp(event.id),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Styles.accent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Join Event',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _shareEvent(event),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.textPrimary,
                            side: const BorderSide(color: Styles.deepTeal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: Styles.textMuted,
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: Styles.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final String initials;
  final String name;
  final String subtitle;
  final bool highlight;

  const _ParticipantRow({
    required this.initials,
    required this.name,
    required this.subtitle,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: highlight ? Styles.selectedFill : Styles.fieldFill,
            border: Border.all(
              color: highlight ? Styles.aqua : Styles.cardBorder,
            ),
          ),
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: highlight ? Styles.aqua : Styles.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

