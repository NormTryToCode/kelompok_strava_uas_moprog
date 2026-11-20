import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class PostComposerCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTapCompose;
  final VoidCallback onTapPhoto;

  const PostComposerCard({
    super.key,
    required this.club,
    required this.onTapCompose,
    required this.onTapPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTapCompose,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 18,
      child: Row(
        children: [
          ClubAvatar(club: club, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Palette.fieldFill,
                borderRadius: BorderRadius.circular(Radii.field),
                border: Border.all(color: Palette.cardBorder),
              ),
              child: const Text(
                'Share an update with the club...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Styles.tabInactive),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Palette.teal.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTapPhoto,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Palette.teal,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}