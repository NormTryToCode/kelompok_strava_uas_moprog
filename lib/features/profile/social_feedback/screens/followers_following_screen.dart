import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

class FollowersFollowingView extends ConsumerStatefulWidget {
  final int initialTabIndex;
  final VoidCallback onBack;
  final VoidCallback? onFindAthletes;

  const FollowersFollowingView({
    super.key,
    required this.initialTabIndex,
    required this.onBack,
    this.onFindAthletes,
  });

  @override
  ConsumerState<FollowersFollowingView> createState() =>
    _FollowersFollowingViewState();
}

class _FollowersFollowingViewState
  extends ConsumerState<FollowersFollowingView> {
    late int _activeTab;
    
  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
  }

  Widget _buildNetworkPill({
    required int index,
    required String label,
  }) {
    final bool isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isSelected ? Styles.primaryGradient : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow:
              isSelected ? Styles.glow(intensity: 0.25, blur: 10) : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
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
    final bool isFollowingTab = (_activeTab == 0);
    final List<String> followingIds = ref.watch(followProvider).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
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
                      'Athlete Network',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    Text(
                      'Training Partners & Connections',
                      overflow: TextOverflow.ellipsis,
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Styles.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Styles.borderStrong),
            ),
            child: Row(
              children: [
                _buildNetworkPill(
                  index: 0,
                  label: 'Following (${followingIds.length})',
                ),
                _buildNetworkPill(
                  index: 1,
                  label: 'Followers (0)',
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: isFollowingTab && followingIds.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                itemCount: followingIds.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final String athleteId = followingIds[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    decoration: Styles.cardDecoration(radius: Radii.card),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: Styles.coverFor(athleteId),
                            border: Border.all(
                              color: Styles.primaryLight.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.directions_run_rounded,
                            color: Styles.textPrimary,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                athleteId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: Styles.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Stride Community Athlete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Styles.surfaceElevated,
                            foregroundColor: Styles.primaryLight,
                            side: const BorderSide(color: Styles.primary),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.chip),
                            ),
                          ),
                          onPressed: () {
                            ref
                              .read(followProvider.notifier)
                              .toggle(athleteId);
                          },
                          child: const Text(
                            'Unfollow',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Styles.surfaceElevated,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Styles.primary.withValues(alpha: 0.45),
                          ),
                          boxShadow: Styles.ambientGlow(),
                        ),
                        child: Icon(
                          isFollowingTab
                            ? Icons.group_add_rounded
                            : Icons.groups_rounded,
                          size: 42,
                          color: Styles.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        isFollowingTab
                          ? 'Not Following Anyone Yet'
                          : 'No Followers Yet',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFollowingTab
                          ? 'Follow athletes from the Groups and Home tabs to track their weekly pace and share kudos.'
                          : 'Stay consistent and share your Athlete Pass card to grow your Stride pack.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: Styles.textSecondary,
                        ),
                      ),
                      if (isFollowingTab) ...[
                        const SizedBox(height: 22),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                    BorderRadius.circular(Radii.button),
                                ),
                              ),
                              onPressed: () {
                                if (widget.onFindAthletes != null) {
                                  widget.onFindAthletes!();
                                } else {
                                  widget.onBack();
                                }
                              },
                              icon: const Icon(Icons.explore_rounded),
                              label: const Text(
                                'Discover Athletes',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
        ),
      ],
    );
  }
}