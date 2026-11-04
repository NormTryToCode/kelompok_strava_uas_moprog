import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class RadioDot extends StatelessWidget {
  final bool selected;

  const RadioDot({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Styles.accent : Colors.white,
          width: 2.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.accent,
              ),
            )
          : null,
    );
  }
}
