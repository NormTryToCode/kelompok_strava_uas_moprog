import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CheckBoxWidget extends StatefulWidget {
  final String checkBoxText;

  const CheckBoxWidget({super.key, required this.checkBoxText});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          activeColor: Styles.badge,
          side: const BorderSide(color: Colors.white),
        ),
        Text(
          widget.checkBoxText,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
