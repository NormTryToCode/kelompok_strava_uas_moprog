import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class FollowersFollowingView extends StatefulWidget {
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
  State<FollowersFollowingView> createState() => _FollowersFollowingViewState();
}

class _FollowersFollowingViewState extends State<FollowersFollowingView> {
  late int _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bool isFollowingTab = (_activeTab == 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(Icons.arrow_back, color: Styles.primaryLight),
              ),
              const SizedBox(width: 20),
              Text(
                isFollowingTab ? 'Mengikuti' : 'Para pengikut',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.primaryLight,
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
                      'Mengikuti',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isFollowingTab
                            ? Styles.primaryLight
                            : Styles.surfaceHighlight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 3,
                      color: isFollowingTab ? Styles.accent : Styles.canvas,
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
                      'Para pengikut',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: !isFollowingTab
                            ? Styles.primaryLight
                            : Styles.surfaceHighlight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 110,
                      height: 3,
                      color: !isFollowingTab ? Styles.accent : Styles.canvas,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(height: 1, color: Styles.surfaceHighlight),
        Padding(
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
                  color: Styles.primaryLight,
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
                      foregroundColor: Styles.primaryLight,
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
                        color: Styles.primaryLight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

