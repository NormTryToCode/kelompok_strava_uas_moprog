import 'package:flutter/material.dart';
import '../widgets/trophy_card.dart';

class TrophyCaseView extends StatelessWidget {
  const TrophyCaseView ({super.key});

  static const millestoneNames = [
    'Aktivitas Pertama',
    'Aktivitas Ketiga',
    'Aktivitas Kelima',
    'Aktivitas Ke10',
    'Aktivitas Ke20',
    'Aktivitas ke30'
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
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(millestoneNames.length, (index) {
        return TrophyCard(
          imageURL : trophyIcons[index],
          milestoneTitle: millestoneNames[index],
        );
      }),
    );
  }
}