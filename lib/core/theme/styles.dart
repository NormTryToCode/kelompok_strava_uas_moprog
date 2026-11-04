import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/gradient_extensions.dart';

class Styles {
  Styles._();

  static const background = Color(0xFF060B14);
  static const accent = Color(0xFFEF5B25);
  static const tabActive = Colors.white;
  static const tabInactive = Color(0xFFD8DADB);
  static const divider = Color(0xFF12403C);
  static const badge = Color(0xFFC04E01);

  static const surface = Color(0xFF0F1826);
  static const active = Color(0xFF8CD45B);
  static const inactive = Color(0xFF2A3442);

  static final gradientOrangeBright = [
    const Color(0xFFEFD7AB),
    const Color(0xFFC04E01),
  ].toBottom();

  static final gradientGrayToDark = [
    const Color(0xFFD8DADB),
    background,
  ].toBottom();

  static final gradientDarkDeep = [
    const Color(0xFF12403C),
    background,
  ].toBottom();
}
