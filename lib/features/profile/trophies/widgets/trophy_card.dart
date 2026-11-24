import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../../shared/utils/profile_page_route.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';
import '../screens/trophy_detail_screen.dart';

class TrophyCard extends ConsumerWidget {
  final TrophyBadge badge;

  const TrophyCard({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentActivities = ref.watch(runSessionsProvider);
    final bool isClaimed = ref.watch(claimedTrophiesProvider).contains(badge.id);
    final bool isUnlocked =
      isClaimed || (currentActivities >= badge.requiredActivities);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          buildProfileRoute(TrophyDetailScreen(badge: badge)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: isUnlocked
                ? BoxDecoration(
                    gradient: Styles.primaryGradient,
                    borderRadius: BorderRadius.circular(Radii.field),
                    boxShadow: Styles.glow(intensity: 0.28, blur: 12),
                  )
                : BoxDecoration(
                    color: Styles.surfaceElevated,
                    borderRadius: BorderRadius.circular(Radii.field),
                    border: Border.all(color: Styles.borderStrong),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badge.watermarkNumber,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Styles.canvas : Styles.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                    size: 24,
                    color: isUnlocked ? Styles.canvas : Styles.primaryLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6.0),
            Flexible(
              child: Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? Styles.primaryLight : Styles.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}