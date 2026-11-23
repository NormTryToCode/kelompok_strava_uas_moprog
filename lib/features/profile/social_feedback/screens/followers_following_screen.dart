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
                isFollowingTab ? 'Mengikuti' : 'Para pengikut',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                        fontWeight: FontWeight.bold,
                        color: isFollowingTab
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 110,
                      height: 3,
                      color:
                        isFollowingTab ? Styles.accent : Styles.canvas,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
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
                        fontWeight: FontWeight.bold,
                        color: !isFollowingTab
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 3,
                      color:
                        !isFollowingTab ? Styles.accent : Styles.canvas,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(height: 1, color: Styles.textMuted),
        Expanded(
          child: isFollowingTab && followingIds.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: followingIds.length,
                separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final String athleteId = followingIds[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.surface,
                      borderRadius: BorderRadius.circular(Radii.chip),
                      border: Border.all(color: Styles.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Styles.deepTeal,
                              child: Icon(
                                Icons.person,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              athleteId,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.accent,
                            side: const BorderSide(color: Styles.accent),
                          ),
                          onPressed: () {
                            ref
                              .read(followProvider.notifier)
                              .toggle(athleteId);
                          },
                          child: const Text('Batal Ikuti'),
                        ),
                      ],
                    ),
                  );
                },
              )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        isFollowingTab
                          ? 'Anda belum mengikuti siapa pun'
                          : 'Anda saat ini tidak memiliki pengikut',
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.accent,
                              foregroundColor: Styles.textPrimary,
                            ),
                            onPressed: () {
                              if (widget.onFindAthletes != null) {
                                widget.onFindAthletes!();
                              }
                            },
                            child: const Text(
                              'Cari Atlet',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Styles.textPrimary,
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