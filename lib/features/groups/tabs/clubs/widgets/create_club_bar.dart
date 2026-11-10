import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class CreateClubBar extends StatelessWidget {
  final VoidCallback onCreate;

  const CreateClubBar({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(18),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF123B3A), Color(0xFF0F1826)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Start your own club',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Bring your crew together, share routes, and plan events.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Styles.tabInactive,
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Create club',
                  icon: Icons.add,
                  height: 44,
                  expand: false,
                  onPressed: onCreate,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const IconBubble(Icons.groups_2_outlined, size: 64),
        ],
      ),
    );
  }
}
