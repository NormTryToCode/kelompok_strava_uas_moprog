import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/challenge_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/challenge_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/widgets/challenge_badge_emblem.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/widgets/challenge_swipe_deck.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class ChallengesTab extends ConsumerStatefulWidget {
  const ChallengesTab({super.key});

  @override
  ConsumerState<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends ConsumerState<ChallengesTab> {
  String? _selectedSportId;
  String? _spotlightId;

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);
    if (challengesAsync.isLoading && !challengesAsync.hasValue) {
      return const Center(
        child: CircularProgressIndicator(color: Styles.primary),
      );
    }

    final allChallenges = challengesAsync.valueOrNull ?? const <Challenge>[];
    if (_spotlightId == null && allChallenges.isNotEmpty) {
      _spotlightId =
          allChallenges[math.Random().nextInt(allChallenges.length)].id;
    }

    final spotlight = allChallenges.isEmpty
        ? null
        : allChallenges.firstWhere(
            (c) => c.id == _spotlightId,
            orElse: () => allChallenges.first,
          );

    final filtered = _selectedSportId == null
        ? allChallenges
        : allChallenges
              .where(
                (c) =>
                    c.qualifyingSportIds.contains(_selectedSportId) ||
                    c.qualifyingSportIds.contains(ClubSport.allSports.id),
              )
              .toList();
    final joined = allChallenges.where((c) => c.isJoined).toList();

    final filterSports = [
      (null, 'All', Icons.auto_awesome_outlined),
      ('running', 'Run', Icons.directions_run),
      ('cycling', 'Ride', Icons.directions_bike),
      ('swimming', 'Swim', Icons.pool),
      ('walking', 'Walk', Icons.directions_walk),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 28),
      children: [
        if (spotlight != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SpotlightChallengeCard(
              challenge: spotlight,
              onTap: () => ChallengeDetailPage.open(context, spotlight),
              onToggleJoin: () => ref
                  .read(challengesProvider.notifier)
                  .toggleJoin(spotlight.id),
            ),
          ),
          const SizedBox(height: 18),
        ],
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filterSports.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final item = filterSports[index];
              final selected = _selectedSportId == item.$1;
              return Material(
                color: selected ? Styles.surfaceHighlight : Styles.surface,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: selected ? Styles.primary : Styles.border,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => setState(() => _selectedSportId = item.$1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(
                          item.$3,
                          size: 15,
                          color: selected
                              ? Styles.primaryLight
                              : Styles.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? Styles.textPrimary
                                : Styles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Discover Challenges',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
              ),
              Text(
                'Swipe card',
                style: TextStyle(fontSize: 12, color: Styles.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: filtered.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(24),
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  child: const Center(
                    child: Text(
                      'No challenges for this sport yet.',
                      style: TextStyle(color: Styles.textSecondary),
                    ),
                  ),
                )
              : ChallengeSwipeDeck(
                  challenges: filtered,
                  onOpenDetail: (ch) => ChallengeDetailPage.open(context, ch),
                  onToggleJoin: (ch) =>
                      ref.read(challengesProvider.notifier).toggleJoin(ch.id),
                ),
        ),
        if (joined.isNotEmpty) ...[
          const SizedBox(height: 26),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your Active Challenges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (var i = 0; i < joined.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  InkWell(
                    onTap: () => ChallengeDetailPage.open(context, joined[i]),
                    borderRadius: BorderRadius.circular(Radii.card),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: Styles.cardDecoration(radius: Radii.card),
                      child: Row(
                        children: [
                          ChallengeBadgeEmblem(
                            code: joined[i].reward.badgeCode,
                            seedId: joined[i].id,
                            sportIcon: joined[i].qualifyingSports.isNotEmpty
                                ? joined[i].qualifyingSports.first.icon
                                : ClubSport.allSports.icon,
                            size: 46,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  joined[i].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${formatChallengeTarget(joined[i])} \u00b7 ${joined[i].organizingClubName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Styles.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Styles.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SpotlightChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onTap;
  final VoidCallback onToggleJoin;

  const _SpotlightChallengeCard({
    required this.challenge,
    required this.onTap,
    required this.onToggleJoin,
  });

  @override
  Widget build(BuildContext context) {
    final primarySport = challenge.qualifyingSports.isNotEmpty
        ? challenge.qualifyingSports.first
        : ClubSport.allSports;

    return Container(
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        highlighted: true,
        withGlow: true,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.primary.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Styles.primaryLight.withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: Styles.primaryLight,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDate(challenge.endDate),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChallengeBadgeEmblem(
                      code: challenge.reward.badgeCode,
                      seedId: challenge.id,
                      sportIcon: primarySport.icon,
                      size: 54,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${formatChallengeTarget(challenge)} \u00b7 ${challenge.organizingClubName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: onToggleJoin,
                      style: FilledButton.styleFrom(
                        backgroundColor: challenge.isJoined
                            ? Styles.surfaceHighlight
                            : Styles.primary,
                        foregroundColor: Styles.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.chip),
                          side: challenge.isJoined
                              ? const BorderSide(color: Styles.primary)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        challenge.isJoined ? 'Joined' : 'Join',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}