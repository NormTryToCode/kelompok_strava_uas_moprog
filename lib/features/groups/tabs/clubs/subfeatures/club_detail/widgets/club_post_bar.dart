import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubPostBar extends StatelessWidget {
  final VoidCallback onTap;

  const ClubPostBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.background,
      child: InkWell(
        onTap: onTap,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Styles.inactive,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Post something...',
                    style: TextStyle(fontSize: 17, color: Styles.tabInactive),
                  ),
                ),
                const Icon(Icons.image_outlined, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
