import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
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
          MaterialPageRoute(
            builder: (context) => TrophyDetailScreen(badge: badge),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: isUnlocked
                ? Styles.gradientOrangeBright
                : const BoxDecoration(color: Styles.surface),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badge.watermarkNumber,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Styles.background : Styles.inactive,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                    size: 26,
                    color: isUnlocked ? Styles.background : Styles.tabActive,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Styles.accent : Styles.tabActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}