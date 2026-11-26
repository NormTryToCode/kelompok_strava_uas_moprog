import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/widgets/challenge_badge_emblem.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class ChallengeSwipeDeck extends StatefulWidget {
  final List<Challenge> challenges;
  final ValueChanged<Challenge> onOpenDetail;
  final ValueChanged<Challenge> onToggleJoin;

  const ChallengeSwipeDeck({
    super.key,
    required this.challenges,
    required this.onOpenDetail,
    required this.onToggleJoin,
  });

  @override
  State<ChallengeSwipeDeck> createState() => _ChallengeSwipeDeckState();
}

class _ChallengeSwipeDeckState extends State<ChallengeSwipeDeck> {
  int _activeIndex = 0;
  double _dragOffsetX = 0;
  int _lastDirection = 1;

  @override
  void didUpdateWidget(covariant ChallengeSwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_activeIndex >= widget.challenges.length) {
      _activeIndex = 0;
    }
  }

  void _step(int delta) {
    if (widget.challenges.length <= 1) return;
    setState(() {
      _lastDirection = delta;
      _dragOffsetX = 0;
      _activeIndex =
          (_activeIndex + delta + widget.challenges.length) %
          widget.challenges.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.challenges;
    if (items.isEmpty) return const SizedBox.shrink();

    final current = items[_activeIndex];
    final nextIndex =
        items.length > 1 ? (_activeIndex + 1) % items.length : null;
    final backIndex =
        items.length > 2 ? (_activeIndex + 2) % items.length : null;

    return Column(
      children: [
        SizedBox(
          height: 368,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (backIndex != null)
                Positioned(
                  top: 24,
                  left: 26,
                  right: 26,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 260),
                    opacity: 0.35,
                    child: Transform.scale(
                      scale: 0.92,
                      child: IgnorePointer(
                        child: _ChallengeDeckCard(
                          challenge: items[backIndex],
                          onOpen: () {},
                          onToggleJoin: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              if (nextIndex != null)
                Positioned(
                  top: 12,
                  left: 14,
                  right: 14,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 260),
                    opacity: 0.65,
                    child: Transform.scale(
                      scale: 0.96,
                      child: IgnorePointer(
                        child: _ChallengeDeckCard(
                          challenge: items[nextIndex],
                          onOpen: () {},
                          onToggleJoin: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() => _dragOffsetX += details.delta.dx);
                  },
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (_dragOffsetX < -65 || velocity < -380) {
                      _step(1);
                    } else if (_dragOffsetX > 65 || velocity > 380) {
                      _step(-1);
                    } else {
                      setState(() => _dragOffsetX = 0);
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 360),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final isIncoming =
                          child.key == ValueKey<String>(current.id);
                      if (isIncoming) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.92,
                              end: 1.0,
                            ).animate(animation),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.06),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          ),
                        );
                      }
                      final exitOffset = Offset(
                        _lastDirection >= 0 ? -0.45 : 0.45,
                        -0.05,
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: exitOffset,
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Transform.translate(
                      key: ValueKey<String>(current.id),
                      offset: Offset(_dragOffsetX, 0),
                      child: Transform.rotate(
                        angle: (_dragOffsetX / 900).clamp(-0.14, 0.14),
                        child: _ChallengeDeckCard(
                          challenge: current,
                          onOpen: () => widget.onOpenDetail(current),
                          onToggleJoin: () => widget.onToggleJoin(current),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (items.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < items.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3.5),
                  width: i == _activeIndex ? 20 : 6.5,
                  height: 6.5,
                  decoration: BoxDecoration(
                    color: i == _activeIndex
                        ? Styles.primaryLight
                        : Styles.borderStrong,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: i == _activeIndex
                        ? Styles.glow(intensity: 0.35, blur: 8)
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ChallengeDeckCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onOpen;
  final VoidCallback onToggleJoin;

  const _ChallengeDeckCard({
    required this.challenge,
    required this.onOpen,
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
        withGlow: true,
        borderColor: Styles.borderGlow.withValues(alpha: 0.45),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChallengeBadgeEmblem(
                      code: challenge.reward.badgeCode,
                      seedId: challenge.id,
                      sportIcon: primarySport.icon,
                      size: 62,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Styles.surfaceElevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Styles.borderStrong),
                            ),
                            child: Text(
                              '${formatDate(challenge.startDate)} – ${formatDate(challenge.endDate)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Styles.primaryLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            challenge.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  challenge.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.fieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Styles.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        size: 17,
                        color: Styles.primaryLight,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formatChallengeTarget(challenge),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          challenge.organizingClubName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Styles.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          onPressed: onToggleJoin,
                          style: FilledButton.styleFrom(
                            backgroundColor: challenge.isJoined
                                ? Styles.surfaceHighlight
                                : Styles.primary,
                            foregroundColor: Styles.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.button),
                              side: challenge.isJoined
                                  ? const BorderSide(color: Styles.primary)
                                  : BorderSide.none,
                            ),
                          ),
                          child: Text(
                            challenge.isJoined ? 'Joined' : 'Join Challenge',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: onOpen,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Styles.textPrimary,
                          side: const BorderSide(color: Styles.borderStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.button),
                          ),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
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