import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubCardItem extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubCardItem({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 68,
                decoration: BoxDecoration(
                  gradient: Palette.coverFor(club.id),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Radii.card - 1),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: -26,
                child: ClubAvatar(club: club, size: 54),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(club.sport.icon, size: 14, color: Styles.tabInactive),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        club.sport.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InfoChip(icon: Icons.people_outline, label: club.memberLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
