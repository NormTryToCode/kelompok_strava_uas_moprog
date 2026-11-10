import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;
  final double radius;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
    this.radius = Radii.card,
  });

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? Styles.surface) : null,
          gradient: gradient,
          borderRadius: shape,
          border: Border.all(
            color: borderColor ?? Palette.cardBorder,
            width: borderWidth,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: shape,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
