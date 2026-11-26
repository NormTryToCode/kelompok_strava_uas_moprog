import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/register/widgets/register_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Styles.radialGlow(intensity: 0.22, radius: 1.1),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Center(child: RegisterWidget()),
              if (Navigator.canPop(context))
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
