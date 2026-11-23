import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../models/trophy_badge.dart';
import '../widgets/trophy_card.dart';

class MilestoneAllScreen extends StatefulWidget {
  final List<TrophyBadge> badges;
  final int currentActivities;
  final ValueChanged<String>? onToggleClaim;

  const MilestoneAllScreen({
    super.key,
    required this.badges,
    this.currentActivities = 0,
    this.onToggleClaim,
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
        backgroundColor: Styles.canvas,
        appBar: AppBar(
          backgroundColor: Styles.canvas,
          title: const Text(
            'Tonggak pencapaian',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Styles.primaryLight,
            ),
          ),
          iconTheme: const IconThemeData(color: Styles.primaryLight),
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
                  onToggleClaim: widget.onToggleClaim,
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

