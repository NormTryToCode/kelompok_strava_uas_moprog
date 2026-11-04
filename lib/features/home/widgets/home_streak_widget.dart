import 'dart:math';

import 'package:flutter/material.dart';

class HomeStreakWidget extends StatelessWidget {
  const HomeStreakWidget({super.key});

  final int dayStreak = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text(
              'Hello user',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Streak: $dayStreak days',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 30,
          child: Icon(Icons.person, size: 32),
        ),
      ],
    );
  }
}
