import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubChannelsHeaderCard extends StatelessWidget {
  final Club club;
  final int channelCount;

  const ClubChannelsHeaderCard({
    super.key,
    required this.club,
    required this.channelCount,
  });

  @override
  Widget build(BuildContext context) {
    final channelLabel =
        channelCount == 1 ? '1 Channel' : '$channelCount Channels';

    return SoftCard(
      padding: const EdgeInsets.all(16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF123B3A), Styles.surface],
      ),
      child: Row(
        children: [
          ClubAvatar(club: club, size: 58),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    InfoChip(
                      icon: Icons.people_outline,
                      label: club.memberLabel,
                    ),
                    InfoChip(
                      icon: Icons.forum_outlined,
                      label: channelLabel,
                      color: Palette.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}