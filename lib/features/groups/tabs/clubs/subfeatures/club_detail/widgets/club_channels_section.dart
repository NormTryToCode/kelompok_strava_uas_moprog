import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/channel_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubChannelsSection extends ConsumerWidget {
  final String clubId;
  final VoidCallback onTap;

  const ClubChannelsSection({
    super.key,
    required this.clubId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(clubChannelsProvider(clubId));
    final count = channelsAsync.valueOrNull?.length ?? 1;
    final subtitle = count == 1
        ? '1 active channel \u00b7 Announcements & updates'
        : '$count active channels \u00b7 Tap to view discussions';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Channels'),
        const SizedBox(height: 12),
        SoftCard(
          onTap: onTap,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const IconBubble(Icons.campaign_outlined, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Club Channels',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Styles.surfaceHighlight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Styles.surfaceHighlight),
            ],
          ),
        ),
      ],
    );
  }
}

