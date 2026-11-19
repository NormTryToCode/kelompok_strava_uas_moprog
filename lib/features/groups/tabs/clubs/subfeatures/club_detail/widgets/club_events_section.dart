import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubEventsSection extends StatelessWidget {
  final VoidCallback onCreateEvent;

  const ClubEventsSection({super.key, required this.onCreateEvent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Upcoming events',
          trailing: TextButton.icon(
            onPressed: onCreateEvent,
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Create event',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: TextButton.styleFrom(foregroundColor: Styles.accent),
          ),
        ),
        const SizedBox(height: 8),
        const SoftCard(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                IconBubble(Icons.event_outlined, size: 54),
                SizedBox(height: 12),
                Text(
                  'Nothing scheduled yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Plan a ride, run, or workout for your members.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Styles.tabInactive),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
