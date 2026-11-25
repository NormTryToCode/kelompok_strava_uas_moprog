import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../../shared/utils/profile_page_route.dart';
import '../models/trophy_badge.dart';
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
    final int currentActivities = ref.watch(runSessionsProvider);
    final Set<String> claimedIds = ref.watch(claimedTrophiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Styles.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Styles.borderStrong),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Styles.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trophy Vault',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    Text(
                      'Milestone Crests & Achievements',
                      style: TextStyle(
                        fontSize: 12,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Styles.border),
        Expanded(
          child: trophiesAsync.when(
            data: (allBadges) {
              bool isBadgeUnlocked(TrophyBadge b) =>
                claimedIds.contains(b.id) ||
                currentActivities >= b.requiredActivities;

              final int unlockedTotal =
                allBadges.where(isBadgeUnlocked).length;
              final double vaultRatio = allBadges.isEmpty
                ? 0.0
                : (unlockedTotal / allBadges.length).clamp(0.0, 1.0);
              final TrophyBadge? nextTarget = allBadges
                .where((b) => !isBadgeUnlocked(b))
                .cast<TrophyBadge?>()
                .firstWhere((_) => true, orElse: () => null);
              final previewBadges = allBadges.take(6).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: Styles.cardDecoration(
                        radius: Radii.card,
                        highlighted: true,
                        withGlow: true,
                      ),
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'VAULT COMPLETION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: Styles.primaryLight,
                                ),
                              ),
                              Text(
                                '${(vaultRatio * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Styles.primaryLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$unlockedTotal of ${allBadges.length} Crests Unlocked',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: vaultRatio,
                              minHeight: 8,
                              backgroundColor: Styles.canvas,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Styles.primaryLight,
                              ),
                            ),
                          ),
                          if (nextTarget != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Styles.canvas.withValues(alpha: 0.65),
                                borderRadius:
                                  BorderRadius.circular(Radii.field),
                                border: Border.all(color: Styles.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.track_changes_rounded,
                                    size: 18,
                                    color: Styles.primaryLight,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Next Crest: ${nextTarget.title} (${(nextTarget.requiredActivities - currentActivities).clamp(0, 999)} sessions left)',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Styles.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FEATURED MILESTONES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Styles.primaryLight,
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
                            'See All 18 >',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
                            childAspectRatio: 0.70,
                            crossAxisCount: 3,
                          ),
                        itemCount: previewBadges.length,
                        itemBuilder: (context, index) =>
                          TrophyCard(badge: previewBadges[index]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: Styles.buttonDecoration(
                          radius: Radii.button,
                          withGlow: true,
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Styles.canvas,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.button),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              buildProfileRoute(const MilestoneAllScreen()),
                            );
                          },
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: const Text(
                            'Explore Full Milestone Vault',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
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
                'Failed to load milestone crests.',
                style: TextStyle(color: Styles.danger),
              ),
            ),
          ),
        ),
      ],
    );
  }
}