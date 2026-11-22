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

  static const gold = Color(0xFFF5B041);
  static const goldSurface = Color(0xFF292011);

  static const sky = Color(0xFF38BDF8);
  static const skySurface = Color(0xFF0F2433);

  static const emerald = Color(0xFF34D399);
  static const emeraldSurface = Color(0xFF0E2922);

  static const coral = Color(0xFFFB7185);
  static const coralSurface = Color(0xFF2C141C);

  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);

  static const surfaceElevated = Color(0xFF162235);
  static const fieldFill = Color(0xFF0B121E);
  static const selectedFill = goldSurface;
  static const cardBorder = Color(0xFF1E293B);
  static const cardBorderHighlight = Color(0xFF334155);

  static const teal = gold;
}

class Radii {
  Radii._();

  static const card = 20.0;
  static const field = 14.0;
  static const chip = 14.0;
  static const button = 14.0;
}