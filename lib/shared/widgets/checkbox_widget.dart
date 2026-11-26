import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CheckBoxWidget extends StatefulWidget {
  final String checkBoxText;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  const CheckBoxWidget({
    super.key,
    required this.checkBoxText,
    this.linkText,
    this.onLinkTap,
    this.value,
    this.onChanged,
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

  void _toggle() {
    final checked = widget.value ?? isChecked;
    final next = !checked;
    setState(() {
      isChecked = next;
    });
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final checked = widget.value ?? isChecked;

    final label = Text.rich(
      TextSpan(
        text: widget.checkBoxText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (widget.linkText != null)
            TextSpan(
              text: widget.linkText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
              recognizer: _tapRecognizer,
            ),
        ],
      ),
    );

    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (value) {
            final next = value ?? false;
            setState(() {
              isChecked = next;
            });
            widget.onChanged?.call(next);
          },
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.transparent;
          }),
          checkColor: Styles.primaryDark,
          side: const BorderSide(color: Colors.white, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: widget.linkText == null
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggle,
                  child: label,
                )
              : label,
        ),
      ],
    );
  }
}
