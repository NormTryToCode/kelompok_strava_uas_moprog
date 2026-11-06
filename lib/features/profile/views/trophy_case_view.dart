import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../utils/profile_api_utils.dart';
import '../widgets/trophy_card.dart';
import 'milestone_all_screen.dart';

class TrophyCaseView extends StatefulWidget {
  final VoidCallback onBack;
  final int currentActivities;

  const TrophyCaseView({
    super.key,
    required this.onBack,
    this.currentActivities = 0,
  });

  @override
  State<TrophyCaseView> createState() => _TrophyCaseViewState();
}

class _TrophyCaseViewState extends State<TrophyCaseView> {
  late Future<List<TrophyBadge>> trophyBadges;

  @override
  void initState() {
    super.initState();
    trophyBadges = fetchTrophyBadgeData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton.filled(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: Styles.tabActive),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tempat Trofi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Styles.tabActive,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<TrophyBadge>>(
            future: trophyBadges,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Gagal memuat tonggak pencapaian.',
                    style: TextStyle(color: Styles.accent),
                  ),
                );
              } else if (snapshot.hasData) {
                final allBadges = snapshot.data!;
                final previewBadges = allBadges.take(6).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tonggak pencapaian",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Styles.tabActive,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MilestoneAllScreen(
                                    badges: allBadges,
                                    currentActivities: widget.currentActivities,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: const Text(
                              "Lihat Semua",
                              style: TextStyle(
                                fontSize: 13,
                                color: Styles.tabInactive,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Styles.surface,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      height: 270,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.85,
                          crossAxisCount: 3,
                        ),
                        itemCount: previewBadges.length,
                        itemBuilder: (context, index) {
                          return TrophyCard(
                            badge: previewBadges[index],
                            currentActivities: widget.currentActivities,
                            onStatusChanged: () {
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Styles.accent),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}