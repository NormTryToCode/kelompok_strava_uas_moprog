import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CreateClubBar extends StatelessWidget {
  final VoidCallback onCreate;

  const CreateClubBar({super.key, required this.onCreate});

  static const _surface = Styles.surface;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Let's create your own club",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: onCreate,
            style: OutlinedButton.styleFrom(
              foregroundColor: Styles.accent,
              side: const BorderSide(color: Styles.accent, width: 2),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            child: const Text('Create a Club'),
          )
        ],
      )
    );
  }
}