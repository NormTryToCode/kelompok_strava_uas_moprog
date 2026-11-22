import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CheckBoxWidget extends StatefulWidget {
  final String checkBoxText;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const CheckBoxWidget({
    super.key,
    required this.checkBoxText,
    this.linkText,
    this.onLinkTap,
  });

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;
  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = widget.onLinkTap;
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onLinkTap != widget.onLinkTap) {
      _tapRecognizer.onTap = widget.onLinkTap;
    }
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

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
        Expanded(
          child: Text.rich(
            TextSpan(
              text: widget.checkBoxText,
              style: const TextStyle(color: Colors.white),
              children: [
                if (widget.linkText != null)
                  TextSpan(
                    text: widget.linkText,
                    style: const TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.lightBlueAccent,
                    ),
                    recognizer: _tapRecognizer,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
