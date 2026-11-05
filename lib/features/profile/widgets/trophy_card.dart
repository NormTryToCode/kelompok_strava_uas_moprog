import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../views/trophy_detail_screen.dart';
import 'custom_image_network.dart';
import 'trophy_check_box.dart';

class TrophyCard extends StatelessWidget {
  final TrophyBadge badge;

  const TrophyCard({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridTile(
        header: TrophyCheckBox(badge: badge),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrophyDetailScreen(badge: badge),
              ),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                color: Styles.surface,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageNetwork(
                      imageUrl: badge.imageLow,
                      height: 130.0,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '#${badge.localId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Styles.accent,
                      ),
                    ),
                    Text(
                      badge.name,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}