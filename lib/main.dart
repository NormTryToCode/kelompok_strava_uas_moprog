import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:kelompok_strava_uas_moprog/features/welcome/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // runApp(const MyApp());
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    ),
  );
}
