import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';

class ClubMediaEditor extends StatelessWidget {
  final Club previewClub;
  final VoidCallback onPickCover;
  final VoidCallback onPickAvatar;
  final VoidCallback? onRemoveCover;

  const ClubMediaEditor({
    super.key,
    required this.previewClub,
    required this.onPickCover,
    required this.onPickAvatar,
    this.onRemoveCover,
  });

  @override
  Widget build(BuildContext context) {
    final coverPath = previewClub.coverPath;
    final hasCover = coverPath != null && coverPath.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 34),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.card),
            child: Container(
              height: 154,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: Styles.coverFor(previewClub.id),
                border: Border.all(color: Styles.cardBorder),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasCover)
                    Image.file(
                      File(coverPath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Styles.canvas.withAlpha(140),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasCover && onRemoveCover != null) ...[
                          Material(
                            color: Styles.canvas.withAlpha(190),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onRemoveCover,
                              child: const SizedBox(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Material(
                          color: Styles.canvas.withAlpha(205),
                          shape: StadiumBorder(
                            side: BorderSide(color: Colors.white.withAlpha(45)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: onPickCover,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.edit_outlined,
                                    size: 15,
                                    color: Styles.teal,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    hasCover ? 'Change cover' : 'Upload image',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: -30,
            child: GestureDetector(
              onTap: onPickAvatar,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClubAvatar(
                    club: previewClub,
                    size: 76,
                    ringColor: Styles.canvas,
                  ),
                  Positioned(
                    right: -2,
                    bottom: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: Styles.primaryGradient,
                        border: Border.all(color: Styles.canvas, width: 2.5),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

