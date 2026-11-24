import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Tonggak Pencapaian',
          style: TextStyle(
            color: Styles.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 144,
                  height: 144,
                  decoration: isUnlocked
                      ? BoxDecoration(
                          gradient: Styles.primaryGradient,
                          borderRadius: BorderRadius.circular(Radii.card),
                          boxShadow: Styles.glow(intensity: 0.4, blur: 24),
                        )
                      : Styles.cardDecoration(
                          radius: Radii.card,
                          highlighted: true,
                        ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        badge.watermarkNumber,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? Styles.canvas
                              : Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Icon(
                        isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                        size: 48,
                        color: isUnlocked ? Styles.canvas : Styles.primaryLight,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (isUnlocked ? Styles.success : Styles.primary)
                        .withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isUnlocked ? Styles.success : Styles.primaryLight,
                    ),
                  ),
                  child: Text(
                    isUnlocked
                        ? 'TERBUKA (TERCAPAI)'
                        : 'TERKUNCI ($currentActivities/${badge.requiredActivities} Aktivitas)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Styles.success : Styles.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  decoration: Styles.cardDecoration(radius: Radii.field),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        badge.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.45,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Tandai Klaim Trofi Manual: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Styles.textPrimary,
                            ),
                          ),
                          TrophyCheckBox(badge: badge),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Styles.primaryDark, Styles.primary],
                      ),
                      borderRadius: BorderRadius.circular(Radii.button),
                      boxShadow: Styles.glow(intensity: 0.3, blur: 16),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Styles.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.button),
                        ),
                      ),
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}