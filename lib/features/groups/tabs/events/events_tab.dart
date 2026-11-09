import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/events/widgets/event_card_item.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

    if (_upcoming.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'No upcoming events yet.\nCreate one from your club page.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Styles.tabInactive),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        const Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in _upcoming) ...[
          EventCardItem(
            event: item.event,
            date: item.date,
            onTap: _comingSoon,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
