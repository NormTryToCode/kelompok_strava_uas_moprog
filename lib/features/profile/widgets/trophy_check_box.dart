import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/trophy_badge.dart';

class TrophyCheckBox extends StatefulWidget {
  final TrophyBadge badge;

  const TrophyCheckBox({
    super.key,
    required this.badge,
  });

  @override
  State<TrophyCheckBox> createState() => _TrophyCheckBoxState();
}

class _TrophyCheckBoxState extends State<TrophyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.badge.toggleIsChecked();
        });
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.all(4),
        child: Icon(
          widget.badge.isChecked
            ? Icons.check_box_outlined
            : Icons.check_box_outline_blank,
          color: widget.badge.isChecked ? Styles.accent : Styles.tabInactive,
        ),
      ),
    );
  }
}