import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class TrophyCard extends StatelessWidget {
  final String imageURL;
  final String milestoneTitle;

  const TrophyCard({
    super.key,
    required this.imageURL,
    required this.milestoneTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Styles.surface,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 64,
              child: Image(
                image: NetworkImage(imageURL),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              milestoneTitle,
              style: const TextStyle(
                fontSize: 14,
                color: Styles.tabActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}