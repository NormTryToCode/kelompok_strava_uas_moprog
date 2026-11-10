import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class SelectableCard extends StatelessWidget {
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
    this.enabled = true,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final tappable = enabled || selected;

    return Opacity(
      opacity: tappable ? 1 : 0.4,
      child: Stack(
        children: [
          SoftCard(
            onTap: tappable ? onTap : null,
            color: selected ? Palette.selectedFill : Styles.surface,
            borderColor: selected ? Palette.teal : Palette.cardBorder,
            borderWidth: selected ? 1.8 : 1,
            radius: 18,
            padding: padding,
            child: child,
          ),
          if (selected)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.check_circle, size: 20, color: Palette.teal),
            ),
        ],
      ),
    );
  }
}
