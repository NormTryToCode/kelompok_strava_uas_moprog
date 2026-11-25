import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class CreateClubBar extends StatelessWidget {
  final VoidCallback onCreate;

  const CreateClubBar({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.cardDecoration(
        radius: Radii.card,
        highlighted: true,
        withGlow: true,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _RippleRingPainter()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start your own club',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Bring your crew together and share routes & events.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: Styles.buttonDecoration(
                            radius: Radii.chip,
                            withGlow: true,
                          ),
                          child: InkWell(
                            onTap: onCreate,
                            borderRadius: BorderRadius.circular(Radii.chip),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Styles.textPrimary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Create',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Styles.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Styles.surfaceElevated.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Styles.primaryLight.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: Styles.glow(intensity: 0.22, blur: 18),
                  ),
                  child: const Icon(
                    Icons.groups_outlined,
                    size: 30,
                    color: Styles.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RippleRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width - 48, size.height * 0.5);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 5; i++) {
      paint.color = Styles.primaryLight.withValues(
        alpha: (0.16 - i * 0.025).clamp(0.03, 0.16),
      );
      canvas.drawCircle(center, 28.0 + i * 24.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}