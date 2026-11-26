import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class DailyChallengeWidget extends StatelessWidget {
  const DailyChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: Styles.cardDecoration(withGlow: true),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Styles.primaryDark,
            child: PhosphorIcon(
              PhosphorIconsRegular.sneakerMove,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DAILY CHALLENGE',
                  style: TextStyle(
                    color: Styles.primaryLight,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Run 2.5 km',
                  style: TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Keep your streak alive',
                  style: TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primary,
              foregroundColor: Styles.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            child: const Text(
              'Start',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
