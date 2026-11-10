import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubChannelsSection extends StatelessWidget {
  final VoidCallback onTap;

  const ClubChannelsSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Channels'),
        const SizedBox(height: 12),
        SoftCard(
          onTap: onTap,
          padding: const EdgeInsets.all(14),
          child: const Row(
            children: [
              IconBubble(Icons.campaign_outlined, size: 44),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Updates from club admins',
                      style: TextStyle(fontSize: 13, color: Styles.tabInactive),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Styles.tabInactive),
            ],
          ),
        ),
      ],
    );
  }
}
