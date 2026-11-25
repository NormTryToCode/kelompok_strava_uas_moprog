import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../../shared/utils/profile_page_route.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';
import '../screens/trophy_detail_screen.dart';

class TrophyCard extends ConsumerWidget {
  final TrophyBadge badge;

  const TrophyCard({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentActivities = ref.watch(runSessionsProvider);
    final bool isClaimed = ref.watch(claimedTrophiesProvider).contains(badge.id);
    final bool isUnlocked =
      isClaimed || (currentActivities >= badge.requiredActivities);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          buildProfileRoute(TrophyDetailScreen(badge: badge)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isUnlocked)
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: Styles.glow(intensity: 0.30, blur: 14),
                      ),
                    ),
                  CustomPaint(
                    size: const Size(70, 70),
                    painter: _HexCrestPainter(isUnlocked: isUnlocked),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        badge.watermarkNumber,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isUnlocked
                            ? Styles.canvas
                            : Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Icon(
                        isUnlocked
                          ? Icons.emoji_events_rounded
                          : Icons.lock_outline_rounded,
                        size: 21,
                        color: isUnlocked ? Styles.canvas : Styles.primaryLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6.0),
            Flexible(
              child: Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.18,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked ? Styles.primaryLight : Styles.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              isUnlocked ? badge.tier.toUpperCase() : '$currentActivities/${badge.requiredActivities}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isUnlocked ? Styles.success : Styles.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HexCrestPainter extends CustomPainter {
  final bool isUnlocked;

  const _HexCrestPainter({required this.isUnlocked});

  Path _buildHexPath(Size size, double inset) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = (math.min(size.width, size.height) / 2) - inset;
    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = (math.pi / 3) * i - (math.pi / 2);
      final double x = cx + r * math.cos(angle);
      final double y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path outerHex = _buildHexPath(size, 2);

    if (isUnlocked) {
      final Paint fillPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Styles.primaryLight, Styles.primary],
        ).createShader(Offset.zero & size);
      canvas.drawPath(outerHex, fillPaint);

      final Paint borderPaint = Paint()
        ..color = Styles.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;
      canvas.drawPath(outerHex, borderPaint);
    } else {
      final Paint fillPaint = Paint()..color = Styles.surfaceElevated;
      canvas.drawPath(outerHex, fillPaint);

      final Paint borderPaint = Paint()
        ..color = Styles.borderStrong
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(outerHex, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HexCrestPainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked;
  }
}