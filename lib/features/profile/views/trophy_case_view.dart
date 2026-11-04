import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../widgets/trophy_card.dart';

class TrophyCaseView extends StatelessWidget {
  final VoidCallback onBack;

  const TrophyCaseView({
    super.key,
    required this.onBack,
  });

  static const milestoneNames = [
    'Aktivitas Pertama',
    'Aktivitas Ketiga',
    'Aktivitas Kelima',
    'Aktivitas Ke10',
    'Aktivitas Ke20',
    'Aktivitas Ke30',
  ];

  static const trophyIcons = [
    'https://cdn-icons-png.flaticon.com/512/3112/3112946.png',
    'https://cdn-icons-png.flaticon.com/512/2583/2583344.png',
    'https://cdn-icons-png.flaticon.com/512/2583/2583319.png',
    'https://cdn-icons-png.flaticon.com/512/2583/2583434.png',
    'https://cdn-icons-png.flaticon.com/512/860/860511.png',
    'https://cdn-icons-png.flaticon.com/512/548/548427.png',
  ];

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
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Styles.tabActive),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tempat Trofi",
                style: TextStyle(fontSize: 20, color: Styles.tabActive),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tonggak pencapaian",
                style: TextStyle(fontSize: 14, color: Styles.tabActive),
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(fontSize: 13, color: Styles.tabInactive),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 460,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(milestoneNames.length, (index) {
              return TrophyCard(
                imageURL: trophyIcons[index],
                milestoneTitle: milestoneNames[index],
              );
            }),
          ),
        ),
      ],
    );
  }
}