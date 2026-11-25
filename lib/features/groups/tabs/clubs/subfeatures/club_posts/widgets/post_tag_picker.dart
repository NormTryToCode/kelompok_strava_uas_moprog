import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';

class PostTagPicker extends StatelessWidget {
  final PostTag selected;
  final ValueChanged<PostTag> onChanged;

  const PostTagPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in PostTag.values)
          Material(
            color: tag == selected ? Styles.selectedFill : Styles.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.chip),
              side: BorderSide(
                color: tag == selected ? Styles.teal : Styles.cardBorder,
                width: tag == selected ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              onTap: () => onChanged(tag),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tag.icon,
                      size: 16,
                      color: tag == selected
                          ? Styles.teal
                          : Styles.surfaceHighlight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tag.label,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: tag == selected
                            ? Colors.white
                            : Styles.surfaceHighlight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

