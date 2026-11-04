import 'package:flutter/material.dart';

class HomeStreakWidget extends StatelessWidget {
  const HomeStreakWidget({super.key});

  final int dayStreak = 0;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            'Hello world',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Streak: 0',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
