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

  @override
  Widget build(BuildContext context) {
    final bool isFollowingTab = (_activeTab == 0);
    final List<String> followingIds = ref.watch(followProvider).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                isFollowingTab ? 'Mengikuti' : 'Para Pengikut',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Styles.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _activeTab = 0;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      'Mengikuti (${followingIds.length})',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isFollowingTab
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: isFollowingTab ? Styles.primaryGradient : null,
                        color: isFollowingTab ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _activeTab = 1;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      'Para pengikut (0)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: !isFollowingTab
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: !isFollowingTab ? Styles.primaryGradient : null,
                        color: !isFollowingTab ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(height: 1, color: Styles.border),
        Expanded(
          child: isFollowingTab && followingIds.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: followingIds.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final String athleteId = followingIds[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    decoration: Styles.cardDecoration(radius: Radii.chip),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Styles.surfaceHighlight,
                          child: Icon(
                            Icons.person,
                            color: Styles.primaryLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            athleteId,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: Styles.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Styles.surfaceElevated,
                            foregroundColor: Styles.primaryLight,
                            side: const BorderSide(color: Styles.primary),
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
                            'Batal Ikuti',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      isFollowingTab
                        ? 'Anda belum mengikuti siapa pun.'
                        : 'Anda saat ini belum memiliki pengikut.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Styles.textPrimary,
                      ),
                    ),
                    if (isFollowingTab) const SizedBox(height: 20),
                    if (isFollowingTab)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Styles.primaryDark, Styles.primary],
                            ),
                            borderRadius: BorderRadius.circular(Radii.button),
                            boxShadow: Styles.glow(intensity: 0.3, blur: 14),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Styles.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                  BorderRadius.circular(Radii.button),
                              ),
                            ),
                            onPressed: () {
                              if (widget.onFindAthletes != null) {
                                widget.onFindAthletes!();
                              }
                            },
                            child: const Text(
                              'Cari Atlet',
                              style: TextStyle(
                                fontSize: 15.5,
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
      ],
    );
  }
}