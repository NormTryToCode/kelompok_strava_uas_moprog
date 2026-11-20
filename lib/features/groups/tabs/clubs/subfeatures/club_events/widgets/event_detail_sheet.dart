import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/event_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';

Future<void> showEventDetailSheet(
  BuildContext context, {
  required Event event,
  required DateTime displayDate,
  required bool isPast,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _EventDetailSheetBody(
      initialEvent: event,
      displayDate: displayDate,
      isPast: isPast,
    ),
  );
}

class _EventDetailSheetBody extends ConsumerWidget {
  final Event initialEvent;
  final DateTime displayDate;
  final bool isPast;

  const _EventDetailSheetBody({
    required this.initialEvent,
    required this.displayDate,
    required this.isPast,
  });

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Styles.surface,
        title: const Text(
          'Delete event?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '"${event.name}" will be removed from the club schedule.',
          style: const TextStyle(color: Styles.tabInactive),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Styles.tabInactive),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Styles.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await ref.read(eventsProvider.notifier).deleteEvent(event.id);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${event.name} deleted')),
    );
  }

  String _formatDistance(Event event) {
    final d = event.distance!;
    final text = d == d.roundToDouble() ? d.toStringAsFixed(0) : d.toString();
    return '$text ${event.distanceUnit.label}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider).valueOrNull ?? const <Event>[];
    final event = events.firstWhere(
      (e) => e.id == initialEvent.id,
      orElse: () => initialEvent,
    );
    final dateText =
        '${formatDate(displayDate)} \u00b7 ${formatTime(TimeOfDay.fromDateTime(displayDate))}';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Styles.inactive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBubble(
                  event.sport?.icon ?? event.kind.icon,
                  size: 48,
                  color: isPast ? Styles.tabInactive : Palette.teal,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hosted by ${event.clubName}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, ref, event),
                  icon: const Icon(Icons.delete_outline, color: Styles.accent),
                  tooltip: 'Delete event',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InfoChip(icon: event.kind.icon, label: event.kind.name),
                if (event.sport != null)
                  InfoChip(icon: event.sport!.icon, label: event.sport!.name),
                InfoChip(icon: Icons.people_outline, label: event.rsvpLabel),
                if (event.distance != null)
                  InfoChip(
                    icon: Icons.straighten,
                    label: _formatDistance(event),
                  ),
                if (event.surface != null)
                  InfoChip(icon: Icons.terrain, label: event.surface!.name),
              ],
            ),
            const SizedBox(height: 18),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              title: dateText,
              subtitle: event.recurrence?.summary(event.startsAt),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: event.isVirtual
                  ? Icons.public
                  : Icons.location_on_outlined,
              title: event.placeLabel,
              subtitle: event.isVirtual
                  ? 'Online event'
                  : (event.location?.detail.isNotEmpty == true
                      ? event.location!.detail
                      : null),
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: Palette.cardBorder),
              const SizedBox(height: 14),
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.45,
                  color: Styles.tabInactive,
                ),
              ),
            ],
            if (!isPast) ...[
              const SizedBox(height: 20),
              if (event.isAttending)
                GhostButton(
                  label: 'Going \u00b7 Tap to cancel',
                  icon: Icons.check_circle_outline,
                  onPressed: () =>
                      ref.read(eventsProvider.notifier).toggleRsvp(event.id),
                )
              else
                PrimaryButton(
                  label: 'Join event',
                  icon: Icons.event_available_outlined,
                  onPressed: () =>
                      ref.read(eventsProvider.notifier).toggleRsvp(event.id),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _DetailRow({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: Palette.teal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
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
    );
  }
}