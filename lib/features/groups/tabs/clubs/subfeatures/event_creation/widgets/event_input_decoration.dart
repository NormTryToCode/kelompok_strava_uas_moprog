import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

const eventErrorColor = Color(0xFFFF6B6B);

OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

InputDecoration eventInputDecoration({
  String? hint,
  String? helper,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Styles.tabInactive),
    helperText: helper,
    helperStyle: const TextStyle(fontSize: 13, color: Styles.tabInactive),
    errorText: errorText,
    errorStyle: const TextStyle(fontSize: 13, color: eventErrorColor),
    counterText: '',
    filled: true,
    fillColor: Styles.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: _border(Styles.inactive, 1.5),
    focusedBorder: _border(Styles.accent, 2),
    errorBorder: _border(eventErrorColor, 1.5),
    focusedErrorBorder: _border(eventErrorColor, 2),
  );
}

const eventFieldTextStyle = TextStyle(fontSize: 16, color: Colors.white);

TextInputFormatter decimalFormatter({
  int integerDigits = 5,
  int fractionDigits = 1,
}) {
  final pattern = RegExp('^\\d{0,$integerDigits}(\\.\\d{0,$fractionDigits})?\$');
  return TextInputFormatter.withFunction(
    (oldValue, newValue) => pattern.hasMatch(newValue.text) ? newValue : oldValue,
  );
}
