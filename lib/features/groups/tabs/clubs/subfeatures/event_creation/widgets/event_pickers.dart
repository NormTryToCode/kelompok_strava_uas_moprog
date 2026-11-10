import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

Widget _darkPickerTheme(BuildContext context, Widget? child) {
  return Theme(
    data: ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Palette.teal,
        onPrimary: Styles.background,
        surface: Styles.surface,
        onSurface: Colors.white,
      ),
    ),
    child: child ?? const SizedBox.shrink(),
  );
}

Future<DateTime?> pickEventDate(BuildContext context, DateTime initial) {
  final today = DateTime.now();
  final firstDate = DateTime(today.year, today.month, today.day);

  return showDatePicker(
    context: context,
    initialDate: initial.isBefore(firstDate) ? firstDate : initial,
    firstDate: firstDate,
    lastDate: DateTime(today.year + 5, today.month, today.day),
    builder: _darkPickerTheme,
  );
}

Future<TimeOfDay?> pickEventTime(BuildContext context, TimeOfDay initial) {
  return showTimePicker(
    context: context,
    initialTime: initial,
    builder: _darkPickerTheme,
  );
}
