import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

final ThemeData profileDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Styles.canvas,
  canvasColor: Styles.canvas,
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,
  highlightColor: Styles.surfaceHighlight.withValues(alpha: 0.25),
  hoverColor: Styles.surfaceHighlight.withValues(alpha: 0.2),
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

ThemeData buildProfileDarkTheme() => profileDarkTheme;

PageRoute<T> buildProfileRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    opaque: true,
    barrierColor: Styles.canvas,
    transitionDuration: const Duration(milliseconds: 160),
    reverseTransitionDuration: const Duration(milliseconds: 140),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Theme(
        data: profileDarkTheme,
        child: ColoredBox(
          color: Styles.canvas,
          child: page,
        ),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.035, 0.0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}