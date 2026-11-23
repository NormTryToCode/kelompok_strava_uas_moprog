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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.fieldFill,
          border: Border.all(
            color: Styles.borderStrong,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(Radii.field),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 5),
            if (isSelector)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      valueText ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
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
                  color: Styles.textMuted,
                ),
                padding: EdgeInsets.zero,
                autocorrect: false,
                cursorColor: Styles.primaryLight,
                style: const TextStyle(
                  fontSize: 15,
                  color: Styles.textPrimary,
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}