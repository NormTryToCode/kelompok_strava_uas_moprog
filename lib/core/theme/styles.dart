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

  static final gradientOrangeBright = [champagne, accent].toBottom();

  static final gradientGrayToDark = [silver, background].toBottom();

  static final gradientDarkDeep = [deepTeal, background].toBottom();
}

class Palette {
  Palette._();

  // --- Surfaces (Obsidian Dark) ---
  static const canvas = Color(0xFF07060C);
  static const surface = Color(0xFF110E1B);
  static const surfaceElevated = Color(0xFF1A152B);
  static const surfaceHighlight = Color(0xFF281E46);
  static const fieldFill = Color(0xFF0D0A16);

  // --- Brand & Accent (Luminous Violet) ---
  static const primary = Color(0xFF8B6BFF);
  static const primaryLight = Color(0xFFB59CFF);
  static const primaryDark = Color(0xFF5A3FD6);
  static const secondary = Color(0xFFC9B8FF);
  static const accent = Color(0xFF9F7AEA);

  // --- Semantic Status ---
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFFB7185);

  // --- Borders & Dividers ---
  static const border = Color(0xFF261F3D);
  static const borderStrong = Color(0xFF3E3166);
  static const borderGlow = Color(0xFF8B6BFF);
  static const divider = Color(0xFF1C172E);

  // --- Typography Hierarchy ---
  static const textPrimary = Color(0xFFF8F7FC);
  static const textSecondary = Color(0xFFA69EB8);
  static const textMuted = Color(0xFF6B6282);

  // --- Backward-Compatible Aliases (aman untuk kode lama & rekan tim) ---
  static const teal = primaryLight;
  static const cardBorder = border;
  static const selectedFill = surfaceHighlight;
  static const deepNavy = surface;
  static const deepTeal = borderStrong;
  static const marigold = primary;
  static const aqua = primaryLight;
  static const gold = secondary;

  // --- Default Primary Gradient ---
  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLight, primary],
  );

  // =========================================================================
  // Gradient & Glow Helpers
  // =========================================================================

  /// Gradasi linear fleksibel untuk button, badge, atau accent aktif.
  static LinearGradient linearGradient({
    List<Color> colors = const [primaryLight, primary],
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors);
  }

  /// Gradasi permukaan kartu gelap-ke-ungu halus (gaya kartu info & header).
  static LinearGradient surfaceGradient({
    Color start = surface,
    Color end = surfaceHighlight,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry endAlignment = Alignment.centerRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: endAlignment,
      colors: [start, end],
    );
  }

  /// Gradasi radial untuk efek cahaya latar (cocok di belakang chart/ring/hero).
  static RadialGradient radialGlow({
    Color color = primary,
    double intensity = 0.35,
    double radius = 0.85,
    AlignmentGeometry center = Alignment.center,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: [
        color.withValues(alpha: intensity.clamp(0.0, 1.0)),
        color.withValues(alpha: (intensity * 0.25).clamp(0.0, 1.0)),
        Colors.transparent,
      ],
      stops: const [0.0, 0.55, 1.0],
    );
  }

  /// Efek glow neon berlapis untuk tombol utama, ikon aktif, atau ring progres.
  static List<BoxShadow> glow({
    Color color = primary,
    double intensity = 0.45,
    double blur = 22,
    double spread = 0,
    Offset offset = Offset.zero,
  }) {
    final alpha = intensity.clamp(0.0, 1.0);
    return [
      BoxShadow(
        color: color.withValues(alpha: alpha),
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
      BoxShadow(
        color: primaryLight.withValues(alpha: alpha * 0.45),
        blurRadius: blur * 0.45,
        spreadRadius: spread * 0.5,
        offset: offset,
      ),
    ];
  }

  /// Efek glow lembut dan lebar untuk kartu elevated atau modal.
  static List<BoxShadow> ambientGlow({
    Color color = primaryDark,
    double intensity = 0.32,
    double blur = 36,
    Offset offset = const Offset(0, 10),
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity.clamp(0.0, 1.0)),
        blurRadius: blur,
        spreadRadius: -4,
        offset: offset,
      ),
    ];
  }

  /// Dekorasi kartu siap pakai (opsi gradasi ungu halus + border + glow).
  static BoxDecoration cardDecoration({
    double radius = Radii.card,
    bool highlighted = false,
    bool withGlow = false,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: highlighted ? null : surface,
      gradient: highlighted ? surfaceGradient() : null,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color:
            borderColor ??
            (highlighted ? borderGlow.withValues(alpha: 0.45) : border),
        width: highlighted ? 1.2 : 1,
      ),
      boxShadow: withGlow ? ambientGlow() : null,
    );
  }

  /// Dekorasi tombol CTA utama dengan gradasi dan glow ungu.
  static BoxDecoration buttonDecoration({
    double radius = Radii.button,
    bool withGlow = true,
  }) {
    return BoxDecoration(
      gradient: linearGradient(
        colors: const [primary, primaryLight],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: withGlow ? glow(intensity: 0.4, blur: 20) : null,
    );
  }

  // --- Seeded Cover Gradients (untuk ClubAvatar & Poster) ---
  static const _covers = <List<Color>>[
    [Color(0xFF8B6BFF), Color(0xFF281E46)],
    [Color(0xFF5A3FD6), Color(0xFF110E1B)],
    [Color(0xFFB59CFF), Color(0xFF432C85)],
    [Color(0xFF6D4AFF), Color(0xFF1B1433)],
    [Color(0xFF9F7AEA), Color(0xFF231842)],
    [Color(0xFF4C359E), Color(0xFF0B0816)],
  ];

  static List<Color> coverColors(String seed) {
    final hash = seed.codeUnits.fold<int>(
      0,
      (acc, unit) => (acc * 31 + unit) & 0x7fffffff,
    );
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

