import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class MyLocationButton extends StatelessWidget {
  final bool following;
  final VoidCallback onPressed;

  const MyLocationButton({
    super.key,
    required this.following,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Styles.accent,
      onPressed: onPressed,
      child: Icon(
        following ? Icons.my_location : Icons.location_searching,
        color: Colors.white,
      ),
    );
  }
}