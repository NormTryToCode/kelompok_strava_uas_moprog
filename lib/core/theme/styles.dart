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

class Palette {
  Palette._();

  static const teal = Color(0xFF2DD4BF);

  static const cardBorder = Color(0xFF1C2A3D);
  static const fieldFill = Color(0xFF0B1320);
  static const selectedFill = Color(0xFF0F2A2D);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFEF5B25), Color(0xFFF2832F)],
  );

  static const _covers = <List<Color>>[
    [Color(0xFFEF5B25), Color(0xFFF5A524)],
    [Color(0xFF2DD4BF), Color(0xFF2563EB)],
    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    [Color(0xFF22C55E), Color(0xFF0EA5E9)],
    [Color(0xFFF43F5E), Color(0xFFF97316)],
    [Color(0xFF6366F1), Color(0xFF14B8A6)],
  ];

  static List<Color> coverColors(String seed) {
    final hash = seed.codeUnits
        .fold<int>(0, (acc, unit) => (acc * 31 + unit) & 0x7fffffff);
    return _covers[hash % _covers.length];
  }

  static LinearGradient coverFor(String seed) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: coverColors(seed),
    );
  }
}

class Radii {
  Radii._();

  static const card = 22.0;
  static const field = 14.0;
  static const chip = 12.0;
  static const button = 16.0;
}
