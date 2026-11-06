import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubEventsSection extends StatelessWidget {
  final VoidCallback onCreateEvent;

  const ClubEventsSection({super.key, required this.onCreateEvent});

  @override
  Widget build(BuildContext context) {
    final block = Styles.inactive.withAlpha(150);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'No upcoming events',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: onCreateEvent,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Create an event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Styles.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 96,
                decoration: BoxDecoration(
                  color: block,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bar(color: block, width: 190),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Bar(color: block, width: 28),
                        const SizedBox(width: 8),
                        _Bar(color: block, width: 70),
                        const SizedBox(width: 8),
                        _Bar(color: block, width: 100),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Bar(color: block, width: 60),
                        const SizedBox(width: 8),
                        _Bar(color: block, width: 110),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final Color color;
  final double width;

  const _Bar({required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
