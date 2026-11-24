import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class PopularClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;
  final VoidCallback onJoinTap;

  const PopularClubCard({
    super.key,
    required this.club,
    required this.onTap,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    final coverColors = Styles.coverColors(club.id);
    final isJoined = club.isJoined;

    return Container(
      width: 244,
      decoration: Styles.cardDecoration(radius: Radii.card),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: Styles.coverFor(club.id),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: Styles.glow(
                          color: coverColors.first,
                          intensity: 0.25,
                          blur: 14,
                        ),
                      ),
                      child: Text(
                        club.initials,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Styles.borderStrong),
                      ),
                      child: Text(
                        club.sport.name,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Styles.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  club.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Styles.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        club.location?.name ?? club.locationLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const _MemberDots(),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        club.memberLabel.toLowerCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: isJoined
                          ? BoxDecoration(
                              color: Styles.surfaceHighlight,
                              borderRadius: BorderRadius.circular(Radii.chip),
                              border: Border.all(
                                color: Styles.borderGlow.withValues(alpha: 0.55),
                              ),
                            )
                          : Styles.buttonDecoration(
                              radius: Radii.chip,
                              withGlow: true,
                            ),
                      child: InkWell(
                        onTap: onJoinTap,
                        borderRadius: BorderRadius.circular(Radii.chip),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isJoined ? Icons.check : Icons.add,
                              size: 17,
                              color: isJoined
                                  ? Styles.primaryLight
                                  : Styles.textPrimary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isJoined ? 'Joined' : 'Join club',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isJoined
                                    ? Styles.primaryLight
                                    : Styles.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _MemberDots extends StatelessWidget {
  const _MemberDots();

  @override
  Widget build(BuildContext context) {
    const colors = [Styles.primaryLight, Styles.secondary, Styles.accent];
    return SizedBox(
      width: 38,
      height: 16,
      child: Stack(
        children: [
          for (var i = 0; i < colors.length; i++)
            Positioned(
              left: i * 10.0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i],
                  border: Border.all(color: Styles.surface, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}