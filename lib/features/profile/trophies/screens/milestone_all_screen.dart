import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';
import '../widgets/trophy_card.dart';

class MilestoneAllScreen extends ConsumerStatefulWidget {
  const MilestoneAllScreen({super.key});

  @override
  ConsumerState<MilestoneAllScreen> createState() => _MilestoneAllScreenState();
}

class _MilestoneAllScreenState extends ConsumerState<MilestoneAllScreen> {
  int _filterIndex = 0; 

  Widget _buildFilterChip(int index, String label) {
    final bool isSelected = _filterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filterIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isSelected ? Styles.primaryGradient : null,
            color: isSelected ? null : Styles.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Styles.primaryLight : Styles.borderStrong,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isSelected ? Styles.canvas : Styles.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trophiesAsync = ref.watch(trophyListProvider);
    final int currentActivities = ref.watch(runSessionsProvider);
    final Set<String> claimedIds = ref.watch(claimedTrophiesProvider);

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Milestone Vault',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Styles.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: trophiesAsync.when(
          data: (badges) {
            bool isUnlocked(TrophyBadge b) =>
              claimedIds.contains(b.id) ||
              currentActivities >= b.requiredActivities;

            final int unlockedCount = badges.where(isUnlocked).length;
            final int lockedCount = badges.length - unlockedCount;

            final List<TrophyBadge> visibleBadges = badges.where((b) {
              if (_filterIndex == 1) return isUnlocked(b);
              if (_filterIndex == 2) return !isUnlocked(b);
              return true;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  child: Row(
                    children: [
                      _buildFilterChip(0, 'All (${badges.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip(1, 'Unlocked ($unlockedCount)'),
                      const SizedBox(width: 8),
                      _buildFilterChip(2, 'Locked ($lockedCount)'),
                    ],
                  ),
                ),
                Expanded(
                  child: visibleBadges.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _filterIndex == 1
                                  ? Icons.emoji_events_outlined
                                  : Icons.verified_rounded,
                                size: 46,
                                color: Styles.primaryLight,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _filterIndex == 1
                                  ? 'No crests unlocked yet. Log sessions or tap any crest to claim!'
                                  : 'Every single Stride milestone crest has been unlocked!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  color: Styles.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                        gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.70,
                            crossAxisCount: 3,
                          ),
                        itemCount: visibleBadges.length,
                        itemBuilder: (context, index) =>
                          TrophyCard(badge: visibleBadges[index]),
                      ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Styles.primary),
          ),
          error: (error, _) => Center(
            child: Text(
              'Failed to load vault: $error',
              style: const TextStyle(color: Styles.danger),
            ),
          ),
        ),
      ),
    );
  }
}