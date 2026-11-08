import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_logo_placeholder.dart';

class ClubCardItem extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubCardItem({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              const ClubLogoPlaceholder(size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(club.sport.icon, size: 22, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          club.memberLabel,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'No posts',
                      style: TextStyle(fontSize: 16, color: Styles.tabInactive),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
