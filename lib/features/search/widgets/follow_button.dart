import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onPressed;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isFollowing ? Styles.tabActive : Styles.accent,
        backgroundColor: isFollowing ? Colors.white12 : Colors.transparent,
        shape: const StadiumBorder(),
        side: BorderSide(
          color: isFollowing ? Colors.white24 : Styles.accent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}