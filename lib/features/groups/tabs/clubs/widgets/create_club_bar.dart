import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class CreateClubBar extends StatelessWidget {
  final VoidCallback onCreate;

  const CreateClubBar({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start your own club',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bring your crew together, share routes, and organize events.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: Styles.tabInactive,
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Create club',
            icon: Icons.add,
            height: 42,
            expand: false,
            onPressed: onCreate,
          ),
        ],
      ),
    );
  }
}