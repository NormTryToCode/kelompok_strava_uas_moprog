import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../utils/profile_api_utils.dart';
import '../widgets/trophy_card.dart';

class TrophyCaseView extends StatefulWidget {
  final VoidCallback onBack;

  const TrophyCaseView({
    super.key,
    required this.onBack,
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
                "Tempat Trofi (API Collection)",
                style: TextStyle(fontSize: 20, color: Styles.tabActive),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tonggak pencapaian (Ketuk untuk detail)",
                style: TextStyle(fontSize: 14, color: Styles.tabActive),
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(fontSize: 13, color: Styles.accent),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<List<TrophyBadge>>(
              future: trophyBadges,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'An error has occurred!',
                      style: TextStyle(color: Styles.accent),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final badges = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.78,
                      crossAxisCount: 2,
                    ),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      return TrophyCard(badge: badges[index]);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: Styles.accent),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}