import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/welcome/widgets/video_player_widget.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
          child: Center(
            child: VideoPlayerApp(),
          ),
      ),
    );
  }
}


