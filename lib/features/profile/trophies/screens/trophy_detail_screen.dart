import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';
import '../widgets/trophy_check_box.dart';

class TrophyDetailScreen extends ConsumerWidget {
  final TrophyBadge badge;

  const TrophyDetailScreen({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentActivities = ref.watch(runSessionsProvider);
    final bool isClaimed = ref.watch(claimedTrophiesProvider).contains(badge.id);
    final bool isUnlocked =
      isClaimed || (currentActivities >= badge.requiredActivities);

    return Animate(
      effects: const [FadeEffect()],
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppBar(
          backgroundColor: Styles.surface,
          title: const Text(
            'Detail Tonggak Pencapaian',
            style: TextStyle(color: Styles.tabActive, fontSize: 18),
          ),
          iconTheme: const IconThemeData(color: Styles.tabActive),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: isUnlocked
                        ? Styles.gradientOrangeBright
                        : const BoxDecoration(color: Styles.surface),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge.watermarkNumber,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                ? Styles.background
                                : Styles.inactive,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Icon(
                            isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                            size: 48,
                            color: isUnlocked
                              ? Styles.background
                              : Styles.tabActive,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      badge.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUnlocked
                        ? 'STATUS: TERBUKA (TERCAPAI)'
                        : 'STATUS: TERKUNCI ($currentActivities/${badge.requiredActivities} Aktivitas)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Styles.active : Styles.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: Styles.surface,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            badge.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Styles.tabInactive,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tandai Klaim Trofi Manual: ',
                                style: TextStyle(color: Styles.tabActive),
                              ),
                              TrophyCheckBox(badge: badge),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                          .read(claimedTrophiesProvider.notifier)
                          .toggleClaim(badge.id);
                        if (!context.mounted) return;
                        ProfileSnackbarHelper.showSuccess(
                          context,
                          isClaimed
                            ? 'Klaim trofi "${badge.title}" dibatalkan.'
                            : 'Trofi "${badge.title}" berhasil diklaim!',
                        );
                      },
                      child: Text(
                        isClaimed
                          ? 'Batalkan Klaim Trofi'
                          : 'Simulasi Buka Trofi Ini',
                        style: const TextStyle(color: Styles.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}