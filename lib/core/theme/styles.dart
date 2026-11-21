import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/gradient_extensions.dart';

class Styles {
  Styles._();

  static const background = Color(0xFF060B14);
  static const deepTeal = Color(0xFF12403C);
  static const champagne = Color(0xFFEFD7AB);
  static const silver = Color(0xFFD8DADB);
  static const accent = Color(0xFFC04E01);

  static const tabActive = Colors.white;
  static const tabInactive = silver;
  static const divider = deepTeal;
  static const badge = accent;

  static const surface = Color(0xFF0B161E);
  static const active = Color(0xFF8CD45B);
  static const inactive = Color(0xFF233238);

  static final gradientOrangeBright = [
    champagne,
    accent,
  ].toBottom();

  static final gradientGrayToDark = [
    silver,
    background,
  ].toBottom();

  static final gradientDarkDeep = [
    deepTeal,
    background,
  ].toBottom();
}

class Palette {
  Palette._();

  static const teal = Styles.deepTeal;

  static const cardBorder = Color(0xFF1B3A39);
  static const fieldFill = Color(0xFF0A141B);
  static const selectedFill = Color(0xFF142D2B);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Styles.champagne, Styles.accent],
  );

  static const _covers = <List<Color>>[
    [Color(0xFFEFD7AB), Color(0xFFC04E01)],
    [Color(0xFF12403C), Color(0xFF060B14)],
    [Color(0xFFD8DADB), Color(0xFF12403C)],
    [Color(0xFF2B6F68), Color(0xFF0D262B)],
    [Color(0xFFE29D52), Color(0xFF8F3801)],
    [Color(0xFF47696B), Color(0xFF060B14)],
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

  static const card = 20.0;
  static const field = 14.0;
  static const chip = 14.0;
  static const button = 14.0;
}