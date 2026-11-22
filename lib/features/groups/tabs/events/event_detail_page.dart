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

  List<Person> _resolveParticipants(Event event) {
    final allPeople = buildDummyPeople();
    final byId = {for (final p in allPeople) p.id: p};
    return [
      for (final id in event.participantIds)
        if (byId[id] != null) byId[id]!,
    ];
  }

  String _clubInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDistance(Event event) {
    final d = event.distance!;
    final text = d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
    return '$text ${event.distanceUnit.label}';
  }

  Future<void> _shareEvent(Event event) async {
    final date =
        '${formatDate(event.startsAt)} at ${formatClock24(event.startsAt)}';
    final text = [
      '${event.name} (${event.sport?.name ?? event.kind.name})',
      '$date · ${event.placeLabel}',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${event.name} deleted')),
    );
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
    final topPad = MediaQuery.of(context).padding.top;

    final scheduleLine =
        '${weekdayName(event.startsAt.weekday)}, ${monthName(event.startsAt.month)} ${event.startsAt.day} at ${formatClock24(event.startsAt)}';
    final goingSummary = event.isAttending
        ? (participants.isEmpty
            ? 'You are going'
            : 'You and ${participants.length} others going')
        : '${event.attendeeCount} ${event.attendeeCount == 1 ? 'person' : 'others'} are going';

    return Scaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      if (hasCoords)
                        EventMapPreview(
                          latitude: lat,
                          longitude: lng,
                          height: 190 + topPad,
                          zoom: 15,
                        )
                      else
                        Container(
                          height: 120 + topPad,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Styles.surface,
                            border: Border(
                              bottom: BorderSide(color: Palette.cardBorder),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                event.isVirtual
                                    ? Icons.public
                                    : (event.sport?.icon ?? event.kind.icon),
                                color: Styles.accent,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                event.isVirtual
                                    ? 'Virtual Event'
                                    : event.placeLabel,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Styles.tabInactive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Positioned(
                        top: topPad + 10,
                        left: 14,
                        right: 14,
                        child: Row(
                          children: [
                            _CircleOverlayButton(
                              icon: Icons.arrow_back,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            PopupMenuButton<String>(
                              color: Styles.surface,
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
                                    style: TextStyle(color: Colors.white),
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
                              child: const _CircleOverlayButton(
                                icon: Icons.more_horiz,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DateSquareBadge(date: event.startsAt),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (participants.isNotEmpty)
                                  _AvatarStack(people: participants),
                                const SizedBox(height: 6),
                                Text(
                                  goingSummary,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Styles.tabInactive,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${formatDate(event.startsAt)} at ${formatClock24(event.startsAt)}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Styles.tabInactive,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _MetaColumn(
                                label: 'Sport',
                                icon: event.sport?.icon ?? event.kind.icon,
                                value: event.sport?.name ?? 'Open Sport',
                              ),
                            ),
                            Expanded(
                              child: _MetaColumn(
                                label: 'Format',
                                value: event.kind.name,
                              ),
                            ),
                            if (event.distance != null)
                              Expanded(
                                child: _MetaColumn(
                                  label: 'Distance',
                                  value: _formatDistance(event),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scheduleLine,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (event.recurrence != null) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      event.recurrence!.summary(event.startsAt),
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        color: Styles.tabInactive,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  OutlinedButton(
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
                                      foregroundColor: Styles.accent,
                                      side: BorderSide(
                                        color: Styles.accent.withAlpha(140),
                                      ),
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Add to Calendar',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              event.isVirtual
                                  ? Icons.public
                                  : Icons.location_on_outlined,
                              size: 21,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.placeLabel,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (!event.isVirtual &&
                                      (event.location?.detail.isNotEmpty ??
                                          false)) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      event.location!.detail,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        color: Styles.tabInactive,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (hasCoords) ...[
                          const SizedBox(height: 14),
                          EventMapPreview(
                            latitude: lat,
                            longitude: lng,
                            height: 156,
                            zoom: 15,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ],
                        if (event.description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.45,
                              color: Styles.tabInactive,
                            ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        const Text(
                          'Hosted By',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SoftCard(
                          padding: const EdgeInsets.all(16),
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
                                      color: Styles.accent.withAlpha(34),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Styles.accent.withAlpha(110),
                                      ),
                                    ),
                                    child: Text(
                                      _clubInitials(event.clubName),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Styles.accent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.clubName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        if (event.clubMemberCount != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            '${event.clubMemberCount!.withThousands} Athletes',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Styles.tabInactive,
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
                                    color: Styles.tabInactive,
                                  ),
                                ),
                              ],
                              if (event.organizerName != null &&
                                  event.organizerName!.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                const Divider(
                                  height: 1,
                                  color: Palette.cardBorder,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Styles.background,
                                      child: Text(
                                        _clubInitials(event.organizerName!),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.organizerName!,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Text(
                                            'Organizer',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Styles.tabInactive,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          '${event.attendeeCount} Going',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (event.isAttending)
                          const _ParticipantRow(
                            initials: 'Y',
                            name: 'You',
                            subtitle: 'Going to this event',
                            highlight: true,
                          ),
                        for (final person in participants)
                          _ParticipantRow(
                            initials: person.initials,
                            name: person.name,
                            subtitle: person.location,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Styles.background,
              border: Border(top: BorderSide(color: Palette.cardBorder)),
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
                                    foregroundColor: Styles.accent,
                                    side: const BorderSide(
                                      color: Styles.accent,
                                    ),
                                    shape: const StadiumBorder(),
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
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    'Join',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _shareEvent(event),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Palette.cardBorder),
                            shape: const StadiumBorder(),
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

class _CircleOverlayButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleOverlayButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: 40,
      height: 40,
      child: Icon(icon, color: Colors.white, size: 21),
    );

    return Material(
      color: Styles.background.withAlpha(190),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
  }
}

class _DateSquareBadge extends StatelessWidget {
  final DateTime date;

  const _DateSquareBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      decoration: BoxDecoration(
        color: Styles.surface,
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
            color: Styles.accent,
            alignment: Alignment.center,
            child: Text(
              monthShort(date.month),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 5, 4, 6),
            child: Column(
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 21,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  weekdayShort(date.weekday),
                  style: const TextStyle(
                    fontSize: 11,
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

class _AvatarStack extends StatelessWidget {
  final List<Person> people;

  const _AvatarStack({required this.people});

  @override
  Widget build(BuildContext context) {
    final shown = people.take(3).toList();
    return SizedBox(
      width: 28 + (shown.length - 1) * 18,
      height: 28,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 18,
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.surface,
                  border: Border.all(color: Styles.background, width: 1.5),
                ),
                child: Text(
                  shown[i].initials,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _MetaColumn({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Styles.tabInactive),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight
                  ? Styles.accent.withAlpha(32)
                  : Styles.surface,
              border: Border.all(
                color: highlight ? Styles.accent : Palette.cardBorder,
              ),
            ),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: highlight ? Styles.accent : Colors.white,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
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