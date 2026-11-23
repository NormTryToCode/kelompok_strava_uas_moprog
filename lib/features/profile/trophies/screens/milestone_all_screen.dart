import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../providers/trophy_provider.dart';
import '../widgets/trophy_card.dart';

class MilestoneAllScreen extends ConsumerWidget {
  const MilestoneAllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trophiesAsync = ref.watch(trophyListProvider);

    return Animate(
      effects: const [FadeEffect()],
      child: Scaffold(
        backgroundColor: Styles.canvas,
        appBar: AppBar(
          backgroundColor: Styles.canvas,
          title: const Text(
            'Tonggak pencapaian',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Styles.textPrimary,
            ),
          ),
          iconTheme: const IconThemeData(color: Styles.textPrimary),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: trophiesAsync.when(
              data: (badges) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.78,
                  crossAxisCount: 3,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) =>
                  TrophyCard(badge: badges[index]),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Styles.accent),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Gagal memuat data: $error',
                  style: const TextStyle(color: Styles.accent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}