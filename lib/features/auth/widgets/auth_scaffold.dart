import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

/// Shared page shell for authentication screens with a radial glow background
/// and an optional floating back button when the route can pop.
class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = showBackButton && Navigator.canPop(context);

    return Scaffold(
      backgroundColor: Styles.canvas,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Styles.radialGlow(intensity: 0.22, radius: 1.1),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(child: child),
              if (canPop)
                Positioned(
                  top: 12,
                  left: 16,
                  child: Material(
                    color: Styles.surfaceElevated,
                    shape: const CircleBorder(
                      side: BorderSide(color: Styles.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Styles.textPrimary,
                      ),
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
