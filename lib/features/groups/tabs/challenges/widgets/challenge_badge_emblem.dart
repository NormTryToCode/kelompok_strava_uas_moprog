import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';

String formatChallengeTarget(Challenge challenge) {
  final v = challenge.targetValue;
  final numText = v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  switch (challenge.metric) {
    case ChallengeMetric.distanceKm:
      return '$numText km';
    case ChallengeMetric.elevationMeters:
      return '$numText m';
    case ChallengeMetric.movingMinutes:
      return '$numText mins';
    case ChallengeMetric.activeDays:
      return '$numText days';
  }
}

String metricLabel(ChallengeMetric metric) {
  switch (metric) {
    case ChallengeMetric.distanceKm:
      return 'Distance (km)';
    case ChallengeMetric.elevationMeters:
      return 'Elevation (m)';
    case ChallengeMetric.movingMinutes:
      return 'Minutes';
    case ChallengeMetric.activeDays:
      return 'Active Days';
  }
}

Color challengeAccentColor(String seedId) => Styles.coverColors(seedId).first;

class ChallengeBadgeEmblem extends StatelessWidget {
  final String code;
  final String seedId;
  final IconData sportIcon;
  final double size;

  const ChallengeBadgeEmblem({
    super.key,
    required this.code,
    required this.seedId,
    required this.sportIcon,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final accent = challengeAccentColor(seedId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.92),
            Styles.surfaceHighlight,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: Styles.primaryLight.withValues(alpha: 0.75),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code.isEmpty ? 'CH' : code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: size * 0.27,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Icon(
            sportIcon,
            size: size * 0.23,
            color: Styles.textPrimary.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}