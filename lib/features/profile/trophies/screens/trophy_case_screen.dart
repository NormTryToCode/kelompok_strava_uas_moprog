import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../providers/trophy_provider.dart';
import '../widgets/trophy_card.dart';
import 'milestone_all_screen.dart';

class TrophyCaseView extends ConsumerWidget {
  final VoidCallback onBack;

  const TrophyCaseView({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trophiesAsync = ref.watch(trophyListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton.filled(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Styles.textPrimary),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tempat Trofi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: trophiesAsync.when(
            data: (allBadges) {
              final previewBadges = allBadges.take(6).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tonggak pencapaian",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Styles.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  const MilestoneAllScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 13,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Styles.surface,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    ),
                    height: 290,
                    child: GridView.builder(
                      gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.78,
                          crossAxisCount: 3,
                        ),
                      itemCount: previewBadges.length,
                      itemBuilder: (context, index) =>
                        TrophyCard(badge: previewBadges[index]),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Styles.accent),
            ),
            error: (error, _) => const Center(
              child: Text(
                'Gagal memuat tonggak pencapaian.',
                style: TextStyle(color: Styles.accent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}