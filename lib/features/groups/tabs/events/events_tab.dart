import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/event_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';

class _UpcomingEvent {
  final Event event;
  final DateTime date;

  const _UpcomingEvent(this.event, this.date);
}

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  List<_UpcomingEvent> _upcoming = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<Event> events;
    try {
      events = await EventRepository.instance.getEvents();
    } catch (_) {
      events = const [];
    }

    final now = DateTime.now();
    final upcoming = <_UpcomingEvent>[];
    for (final event in events) {
      final next = event.nextOccurrence(now);
      if (next != null) upcoming.add(_UpcomingEvent(event, next));
    }
    upcoming.sort((a, b) => a.date.compareTo(b.date));

    if (!mounted) return;
    setState(() {
      _upcoming = upcoming;
      _loading = false;
    });
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  List<MapEntry<String, List<_UpcomingEvent>>> _groupByMonth() {
    final groups = <String, List<_UpcomingEvent>>{};
    for (final item in _upcoming) {
      final key = '${monthName(item.date.month)} ${item.date.year}';
      groups.putIfAbsent(key, () => []).add(item);
    }
    return groups.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

    if (_upcoming.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBubble(Icons.event_busy_outlined, size: 60),
              SizedBox(height: 16),
              Text(
                'No upcoming events yet',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Create one from your club page and it will show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Styles.tabInactive),
              ),
            ],
          ),
        ),
      );
    }

    final groups = _groupByMonth();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final group in groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
            child: Row(
              children: [
                Text(
                  group.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  group.value.length == 1
                      ? '1 event'
                      : '${group.value.length} events',
                  style: const TextStyle(fontSize: 13, color: Styles.tabInactive),
                ),
              ],
            ),
          ),
          for (var i = 0; i < group.value.length; i++)
            EventCardItem(
              event: group.value[i].event,
              date: group.value[i].date,
              isLast: i == group.value.length - 1,
              onTap: _comingSoon,
            ),
        ],
      ],
    );
  }
}
