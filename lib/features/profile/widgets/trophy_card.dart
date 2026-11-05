import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../views/trophy_detail_screen.dart';

class TrophyCard extends StatelessWidget {
  final TrophyBadge badge;
  final int currentActivities;
  final VoidCallback? onStatusChanged;

  const TrophyCard({
    super.key,
    required this.badge,
    this.currentActivities = 0,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked =
        badge.isChecked || (currentActivities >= badge.requiredActivities);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrophyDetailScreen(
              badge: badge,
              currentActivities: currentActivities,
            ),
          ),
        );
        if (onStatusChanged != null) {
          onStatusChanged!();
        }
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
                      color: isUnlocked
                          ? Styles.background
                          : Styles.inactive,
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