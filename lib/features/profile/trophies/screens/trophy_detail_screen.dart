import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../overview/providers/profile_activity_provider.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../models/trophy_badge.dart';
import '../providers/trophy_provider.dart';
import '../widgets/trophy_check_box.dart';

class TrophyDetailScreen extends ConsumerWidget {
  final TrophyBadge badge;

  const TrophyDetailScreen({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentActivities = ref.watch(runSessionsProvider);
    final bool isClaimed = ref.watch(claimedTrophiesProvider).contains(badge.id);
    final bool isUnlocked =
      isClaimed || (currentActivities >= badge.requiredActivities);
    final double progressRatio = isUnlocked
      ? 1.0
      : (currentActivities / badge.requiredActivities).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Crest Inspection',
          style: TextStyle(
            color: Styles.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.surfaceHighlight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Styles.primary.withValues(alpha: 0.55),
                    ),
                  ),
                  child: Text(
                    '${badge.tier.toUpperCase()} TIER CREST',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Styles.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: Styles.radialGlow(
                            color: isUnlocked
                              ? Styles.primary
                              : Styles.primaryDark,
                            intensity: isUnlocked ? 0.45 : 0.2,
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(150, 150),
                        painter: _DetailHexPainter(isUnlocked: isUnlocked),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            badge.watermarkNumber,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: isUnlocked
                                ? Styles.canvas
                                : Styles.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isUnlocked
                              ? Icons.emoji_events_rounded
                              : Icons.lock_outline_rounded,
                            size: 46,
                            color: isUnlocked
                              ? Styles.canvas
                              : Styles.primaryLight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (isUnlocked ? Styles.success : Styles.primary)
                      .withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isUnlocked ? Styles.success : Styles.primaryLight,
                    ),
                  ),
                  child: Text(
                    isUnlocked
                      ? 'UNLOCKED  •  ACHIEVED'
                      : 'LOCKED  •  $currentActivities / ${badge.requiredActivities} SESSIONS',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: isUnlocked ? Styles.success : Styles.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: Styles.cardDecoration(radius: Radii.card),
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        badge.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: Styles.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Milestone Progress',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Styles.textSecondary,
                            ),
                          ),
                          Text(
                            '${(progressRatio * 100).round()}%',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: isUnlocked
                                ? Styles.success
                                : Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressRatio,
                          minHeight: 7,
                          backgroundColor: Styles.canvas,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isUnlocked ? Styles.success : Styles.primaryLight,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1, color: Styles.divider),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Manual Vault Claim',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Styles.textPrimary,
                              ),
                            ),
                          ),
                          TrophyCheckBox(badge: badge),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isClaimed
                          ? const [Styles.surfaceElevated, Styles.surfaceHighlight]
                          : const [Styles.primaryDark, Styles.primary],
                      ),
                      borderRadius: BorderRadius.circular(Radii.button),
                      border: isClaimed
                        ? Border.all(color: Styles.borderStrong)
                        : null,
                      boxShadow: isClaimed
                        ? null
                        : Styles.glow(intensity: 0.32, blur: 16),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Styles.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.button),
                        ),
                      ),
                      onPressed: () async {
                        await ref
                          .read(claimedTrophiesProvider.notifier)
                          .toggleClaim(badge.id);
                        if (!context.mounted) return;
                        ProfileSnackbarHelper.showSuccess(
                          context,
                          isClaimed
                            ? 'Manual claim for "${badge.title}" revoked.'
                            : '"${badge.title}" unlocked in your Trophy Vault!',
                        );
                      },
                      icon: Icon(
                        isClaimed
                          ? Icons.undo_rounded
                          : Icons.auto_awesome_rounded,
                        size: 18,
                      ),
                      label: Text(
                        isClaimed
                          ? 'Revoke Manual Claim'
                          : 'Unlock Crest Preview',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailHexPainter extends CustomPainter {
  final bool isUnlocked;

  const _DetailHexPainter({required this.isUnlocked});

  Path _buildHex(Size size, double inset) {
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
    final Path outer = _buildHex(size, 3);
    final Path inner = _buildHex(size, 11);

    if (isUnlocked) {
      canvas.drawPath(
        outer,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Styles.primaryLight, Styles.primary],
          ).createShader(Offset.zero & size),
      );
      canvas.drawPath(
        outer,
        Paint()
          ..color = Styles.secondary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
      canvas.drawPath(
        inner,
        Paint()
          ..color = Styles.canvas.withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    } else {
      canvas.drawPath(outer, Paint()..color = Styles.surfaceElevated);
      canvas.drawPath(
        outer,
        Paint()
          ..color = Styles.borderStrong
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
      canvas.drawPath(
        inner,
        Paint()
          ..color = Styles.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DetailHexPainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked;
  }
}