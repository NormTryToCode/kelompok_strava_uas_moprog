import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../utils/profile_api_utils.dart';
import '../widgets/custom_image_network.dart';

class TrophyDetailScreen extends StatelessWidget {
  final TrophyBadge badge;

  const TrophyDetailScreen({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect()],
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppBar(
          backgroundColor: Styles.surface,
          title: const Text(
            'Detail Trofi Pencapaian',
            style: TextStyle(color: Styles.tabActive),
          ),
          iconTheme: const IconThemeData(color: Styles.tabActive),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Badge ID: #${badge.localId}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Styles.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.name,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Styles.tabActive,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomImageNetwork(imageUrl: badge.imageHigh),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
                    future: fetchIllustratorName(badge.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Styles.accent,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error fetching illustrator: ${snapshot.error}',
                          style: const TextStyle(color: Styles.accent),
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          'Illustrator: ${snapshot.data}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Styles.tabInactive,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}