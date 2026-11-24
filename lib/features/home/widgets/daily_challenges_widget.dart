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
          CircleAvatar(
            radius: 28,
            backgroundColor: Styles.primaryDark,
            child: PhosphorIcon(
              PhosphorIconsRegular.sneakerMove,
              size: 28,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Today Daily Challenge 🔥',
                  style: TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Run 2.5 Km',
                  style: TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
         ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primary,
              foregroundColor: Styles.textPrimary,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            child: Text(
              'Start',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
