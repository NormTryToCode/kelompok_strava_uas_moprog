import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfileLabeledField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? valueText;
  final VoidCallback? onTap;
  final String placeholder;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileLabeledField({
    super.key,
    required this.label,
    this.controller,
    this.valueText,
    this.onTap,
    this.placeholder = '',
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelector = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.canvas,
          border: Border.all(color: Styles.surfaceHighlight, width: 1.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Styles.surfaceHighlight,
              ),
            ),
            const SizedBox(height: 4),
            if (isSelector)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    valueText ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Styles.primaryLight,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Styles.primaryLight,
                    size: 20,
                  ),
                ],
              )
            else
              CupertinoTextField(
                controller: controller,
                placeholder: placeholder,
                textCapitalization: textCapitalization,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                placeholderStyle: const TextStyle(
                  fontSize: 14,
                  color: Styles.surfaceHighlight,
                ),
                padding: EdgeInsets.zero,
                autocorrect: false,
                style: const TextStyle(
                  fontSize: 15,
                  color: Styles.primaryLight,
                ),
                decoration: const BoxDecoration(color: Styles.canvas),
              ),
          ],
        ),
      ),
    );
  }
}

