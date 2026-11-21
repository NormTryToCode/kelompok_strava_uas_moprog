import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubOverviewSummaryCard extends StatelessWidget {
  final Club club;

  const ClubOverviewSummaryCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final isPrivate = club.privacy.id == ClubPrivacy.private.id;
    final vanity = club.vanityUrl;

    return SoftCard(
      padding: const EdgeInsets.all(16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF123B3A), Styles.surface],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClubAvatar(club: club, size: 58),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    if (club.types.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        club.typeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Palette.teal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(icon: club.sport.icon, label: club.sport.name),
              InfoChip(icon: Icons.people_outline, label: club.memberLabel),
              InfoChip(
                icon: isPrivate ? Icons.lock_outline : Icons.public,
                label: club.privacy.name,
              ),
              InfoChip(
                icon: club.isGlobal ? Icons.public : Icons.place_outlined,
                label: club.locationLabel,
              ),
            ],
          ),
          if (club.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              club.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Styles.tabInactive,
              ),
            ),
          ],
          if (vanity != null && vanity.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.link, size: 15, color: Palette.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'strava.com/clubs/$vanity',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Palette.teal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}