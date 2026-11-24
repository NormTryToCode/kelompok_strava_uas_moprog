import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class YourClubTile extends StatelessWidget {
  final String seedId;
  final String name;
  final String initials;
  final String sportLabel;
  final String locationLabel;
  final String memberLabel;
  final String? avatarPath;
  final String? coverPath;
  final VoidCallback onTap;

  const YourClubTile({
    super.key,
    required this.seedId,
    required this.name,
    required this.initials,
    required this.sportLabel,
    required this.locationLabel,
    required this.memberLabel,
    required this.onTap,
    this.avatarPath,
    this.coverPath,
  });

  @override
  Widget build(BuildContext context) {
    final coverColors = Styles.coverColors(seedId);
    final hasAvatar = avatarPath != null && avatarPath!.isNotEmpty;
    final hasCover = coverPath != null && coverPath!.isNotEmpty;

    return Stack(
      children: [
        if (hasCover)
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(coverPath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Styles.canvas.withValues(alpha: 0.90),
                        Styles.surface.withValues(alpha: 0.72),
                        Styles.surfaceHighlight.withValues(alpha: 0.55),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: Styles.coverFor(seedId),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: Styles.glow(
                        color: coverColors.first,
                        intensity: 0.22,
                        blur: 12,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: hasAvatar
                        ? Image.file(
                            File(avatarPath!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _InitialText(initials),
                          )
                        : _InitialText(initials),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Styles.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$sportLabel \u00b7 $locationLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Styles.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 13.5,
                              color: Styles.textMuted,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                memberLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Styles.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.surfaceElevated.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Styles.borderStrong),
                    ),
                    child: const Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialText extends StatelessWidget {
  final String text;

  const _InitialText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Styles.textPrimary,
      ),
    );
  }
}