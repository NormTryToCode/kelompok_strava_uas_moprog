import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/home/widgets/home_streak_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.0),
          HomeStreakWidget(),
        ],
      ),
    );
  }
}

