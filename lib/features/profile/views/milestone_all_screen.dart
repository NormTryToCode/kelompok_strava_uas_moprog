import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';
import '../widgets/trophy_card.dart';

class MilestoneAllScreen extends StatefulWidget {
  final List<TrophyBadge> badges;
  final int currentActivities;

  const MilestoneAllScreen({
    super.key,
    required this.badges,
    this.currentActivities = 0,
  });

  @override
  State<MilestoneAllScreen> createState() => _MilestoneAllScreenState();
}

class _MilestoneAllScreenState extends State<MilestoneAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [FadeEffect()],
      child: Scaffold(
        backgroundColor: Styles.background,
        appBar: AppBar(
          backgroundColor: Styles.background,
          title: const Text(
            'Tonggak pencapaian',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          iconTheme: const IconThemeData(color: Styles.tabActive),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.82,
                crossAxisCount: 3,
              ),
              itemCount: widget.badges.length,
              itemBuilder: (context, index) {
                return TrophyCard(
                  badge: widget.badges[index],
                  currentActivities: widget.currentActivities,
                  onStatusChanged: () {
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}