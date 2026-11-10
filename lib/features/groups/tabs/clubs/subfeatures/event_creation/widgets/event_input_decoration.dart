import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

const eventErrorColor = Color(0xFFFF6B6B);

OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.field),
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
    fillColor: Palette.fieldFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: _border(Palette.cardBorder, 1.2),
    focusedBorder: _border(Palette.teal, 1.8),
    errorBorder: _border(eventErrorColor, 1.4),
    focusedErrorBorder: _border(eventErrorColor, 1.8),
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
