import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class SheetHandle extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const SheetHandle({super.key, this.margin = const EdgeInsets.only(top: 10)});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: Styles.surfaceHighlight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

