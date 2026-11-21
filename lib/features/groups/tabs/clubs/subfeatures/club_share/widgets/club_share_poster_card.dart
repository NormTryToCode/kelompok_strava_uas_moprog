import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';

class ClubSharePosterCard extends StatelessWidget {
  final GlobalKey posterKey;
  final Club club;
  final String clubUrl;

  const ClubSharePosterCard({
    super.key,
    required this.posterKey,
    required this.club,
    required this.clubUrl,
  });

  @override
  Widget build(BuildContext context) {
    final coverPath = club.coverPath;
    final hasCover = coverPath != null && coverPath.isNotEmpty;
    final colors = Palette.coverColors(club.id);

    return RepaintBoundary(
      key: posterKey,
      child: AspectRatio(
        aspectRatio: 0.64,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.first,
                  colors.last,
                  Styles.background,
                ],
                stops: const [0, 0.58, 1],
              ),
              border: Border.all(
                color: Colors.white.withAlpha(35),
                width: 1.2,
              ),
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
                      colors: hasCover
                          ? [
                              Styles.background.withAlpha(115),
                              Styles.background.withAlpha(175),
                              Styles.background.withAlpha(235),
                            ]
                          : [
                              Colors.black.withAlpha(20),
                              Colors.black.withAlpha(90),
                              Styles.background.withAlpha(215),
                            ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ClubAvatar(
                            club: club,
                            size: 68,
                            ringColor: Colors.white.withAlpha(90),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            club.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                club.sport.icon,
                                size: 14,
                                color: Palette.teal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${club.sport.name} \u00b7 ${club.memberLabel}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Column(
                        children: [
                          Text(
                            'Make some friends.\nGet some kudos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.4,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Join the Club.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 20,
                            color: Palette.teal,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(95),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Palette.teal.withAlpha(150),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.link,
                                  size: 15,
                                  color: Palette.teal,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    clubUrl.replaceFirst('https://', ''),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Join us on',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'STRAVA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}