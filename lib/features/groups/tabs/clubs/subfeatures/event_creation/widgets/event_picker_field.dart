import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';

class EventPickerField extends StatelessWidget {
  final String? value;
  final String placeholder;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onTap;

  const EventPickerField({
    super.key,
    required this.onTap,
    this.value,
    this.placeholder = '',
    this.leadingIcon,
    this.trailing,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final hasValue = value != null && value!.isNotEmpty;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Palette.fieldFill,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.field),
              side: BorderSide(
                color: hasError ? eventErrorColor : Palette.cardBorder,
                width: hasError ? 1.4 : 1.2,
              ),
            ),
            child: InkWell(
              onTap: enabled ? onTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 54,
                  child: Row(
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(leadingIcon, size: 22, color: Palette.teal),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          hasValue ? value! : placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: hasValue ? Colors.white : Styles.tabInactive,
                          ),
                        ),
                      ),
                      trailing ??
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Styles.tabInactive,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                errorText!,
                style: const TextStyle(fontSize: 13, color: eventErrorColor),
              ),
            ),
        ],
      ),
    );
  }
}
