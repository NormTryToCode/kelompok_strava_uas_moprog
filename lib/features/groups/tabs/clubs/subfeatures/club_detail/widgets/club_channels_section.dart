import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubChannelsSection extends StatelessWidget {
  final VoidCallback onTap;

  const ClubChannelsSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Club Channels',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Material(
            color: Styles.background,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Styles.inactive, width: 1.5),
            ),
            child: InkWell(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  children: [
                    Icon(Icons.forum_outlined, size: 24, color: Colors.white),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Announcements',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white),
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
