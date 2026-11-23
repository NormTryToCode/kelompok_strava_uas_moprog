import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

ThemeData buildProfileDarkTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Styles.canvas,
    canvasColor: Styles.canvas,
    splashColor: Styles.primary.withValues(alpha: 0.14),
    highlightColor: Styles.primary.withValues(alpha: 0.08),
    hoverColor: Styles.surfaceHighlight.withValues(alpha: 0.35),
    dividerColor: Styles.divider,
    colorScheme: const ColorScheme.dark(
      primary: Styles.primary,
      onPrimary: Styles.textPrimary,
      secondary: Styles.primaryLight,
      onSecondary: Styles.canvas,
      surface: Styles.surface,
      onSurface: Styles.textPrimary,
      error: Styles.danger,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Styles.canvas,
      foregroundColor: Styles.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

PageRoute<T> buildProfileRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    opaque: true,
    barrierColor: Styles.canvas,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Theme(
        data: buildProfileDarkTheme(),
        child: page,
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.04, 0.0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      );
    },
  );
}