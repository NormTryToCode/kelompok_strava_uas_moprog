import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfileSnackbarHelper {
  ProfileSnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Styles.background,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Palette.success,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Styles.tabActive,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Palette.danger,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Styles.tabActive,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Styles.surface,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}