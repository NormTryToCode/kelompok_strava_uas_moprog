import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/utils/profile_page_route.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Styles.textPrimary),
              ),
              const SizedBox(width: 6),
              const Text(
                'Tempat Trofi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Styles.border),
        Expanded(
          child: trophiesAsync.when(
            data: (allBadges) {
              final previewBadges = allBadges.take(6).toList();
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tonggak Pencapaian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Styles.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              buildProfileRoute(const MilestoneAllScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Styles.primaryLight,
                          ),
                          child: const Text(
                            'Lihat Semua >',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: Styles.cardDecoration(
                        radius: Radii.card,
                        withGlow: true,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 8.0,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.72,
                            crossAxisCount: 3,
                        ),
                        itemCount: previewBadges.length,
                        itemBuilder: (context, index) =>
                          TrophyCard(badge: previewBadges[index]),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Styles.primary),
            ),
            error: (error, _) => const Center(
              child: Text(
                'Gagal memuat tonggak pencapaian.',
                style: TextStyle(color: Styles.danger),
              ),
            ),
          ),
        ),
      ],
    );
  }
}