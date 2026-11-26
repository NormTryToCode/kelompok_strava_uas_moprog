import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/workout_series_model.dart';

/// Procedural neon-purple athlete animation illustrating each workout motion.
class WorkoutFigureAnimation extends StatefulWidget {
  final WorkoutExerciseMotion motion;
  final bool animate;

  const WorkoutFigureAnimation({
    super.key,
    required this.motion,
    this.animate = true,
  });

  @override
  State<WorkoutFigureAnimation> createState() => _WorkoutFigureAnimationState();
}

class _WorkoutFigureAnimationState extends State<WorkoutFigureAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(covariant WorkoutFigureAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      _syncAnimationState();
    }
  }

  void _syncAnimationState() {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    if (!widget.animate || disableAnimations) {
      _controller.stop();
      _controller.value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Styles.surfaceGradient(
            start: Styles.fieldFill,
            end: Styles.surfaceHighlight,
            begin: Alignment.topCenter,
            endAlignment: Alignment.bottomCenter,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: Styles.radialGlow(
              color: Styles.primary,
              intensity: 0.42,
              radius: 0.78,
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _WorkoutFigurePainter(
                  motion: widget.motion,
                  progress: _controller.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorkoutFigurePainter extends CustomPainter {
  final WorkoutExerciseMotion motion;
  final double progress;

  const _WorkoutFigurePainter({
    required this.motion,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final wave = (1 - math.cos(progress * 2 * math.pi)) / 2;
    final unit = math.min(size.width, size.height);
    final cx = size.width * 0.5;
    final floorY = size.height * 0.84;

    _drawFloorStage(canvas, Offset(cx, floorY), unit, wave);

    switch (motion) {
      case WorkoutExerciseMotion.fullBody:
        _paintFullBodyThruster(canvas, cx, floorY, unit, wave);
      case WorkoutExerciseMotion.lowerBody:
        _paintLowerBodyLunge(canvas, cx, floorY, unit, wave);
      case WorkoutExerciseMotion.upperBody:
        _paintUpperBodyPress(canvas, cx, floorY, unit, wave);
      case WorkoutExerciseMotion.core:
        _paintCoreTuck(canvas, cx, floorY, unit, wave);
    }
  }

  void _drawFloorStage(
    Canvas canvas,
    Offset center,
    double unit,
    double wave,
  ) {
    final outerRect = Rect.fromCenter(
      center: center,
      width: unit * 0.78,
      height: unit * 0.14,
    );
    final pulseRect = Rect.fromCenter(
      center: center,
      width: unit * (0.44 + 0.14 * wave),
      height: unit * (0.075 + 0.025 * wave),
    );

    final floorFill = Paint()
      ..color = Styles.primaryDark.withValues(alpha: 0.22);
    final floorBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Styles.borderStrong.withValues(alpha: 0.8);
    final pulseBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Styles.borderGlow.withValues(alpha: 0.45 - 0.2 * wave);

    canvas.drawOval(outerRect, floorFill);
    canvas.drawOval(outerRect, floorBorder);
    canvas.drawOval(pulseRect, pulseBorder);
  }

  void _paintFullBodyThruster(
    Canvas canvas,
    double cx,
    double floorY,
    double unit,
    double wave,
  ) {
    // wave = 0 -> deep squat with rack dumbbells; wave = 1 -> overhead press
    final hipY = floorY - unit * (0.24 + 0.17 * wave);
    final shoulderY = hipY - unit * (0.19 + 0.04 * wave);
    final headCenter = Offset(cx, shoulderY - unit * 0.095);

    final leftFoot = Offset(cx - unit * 0.11, floorY);
    final rightFoot = Offset(cx + unit * 0.11, floorY);
    final kneeSpread = unit * (0.17 - 0.05 * wave);
    final kneeY = floorY - unit * (0.15 + 0.06 * wave);
    final leftKnee = Offset(cx - kneeSpread, kneeY);
    final rightKnee = Offset(cx + kneeSpread, kneeY);
    final leftHip = Offset(cx - unit * 0.055, hipY);
    final rightHip = Offset(cx + unit * 0.055, hipY);
    final leftShoulder = Offset(cx - unit * 0.095, shoulderY);
    final rightShoulder = Offset(cx + unit * 0.095, shoulderY);

    final handLift = unit * (0.04 + 0.27 * wave);
    final handSpread = unit * (0.14 - 0.02 * wave);
    final leftHand = Offset(cx - handSpread, shoulderY - handLift);
    final rightHand = Offset(cx + handSpread, shoulderY - handLift);
    final leftElbow = Offset(
      cx - unit * (0.17 - 0.03 * wave),
      shoulderY + unit * (0.04 - 0.15 * wave),
    );
    final rightElbow = Offset(
      cx + unit * (0.17 - 0.03 * wave),
      shoulderY + unit * (0.04 - 0.15 * wave),
    );

    _drawLimb(canvas, leftFoot, leftKnee, unit * 0.042);
    _drawLimb(canvas, leftKnee, leftHip, unit * 0.045);
    _drawLimb(canvas, rightFoot, rightKnee, unit * 0.042);
    _drawLimb(canvas, rightKnee, rightHip, unit * 0.045);
    _drawTorso(canvas, leftHip, rightHip, leftShoulder, rightShoulder, unit);
    _drawLimb(canvas, leftShoulder, leftElbow, unit * 0.034);
    _drawLimb(canvas, leftElbow, leftHand, unit * 0.032);
    _drawLimb(canvas, rightShoulder, rightElbow, unit * 0.034);
    _drawLimb(canvas, rightElbow, rightHand, unit * 0.032);

    _drawDumbbell(canvas, leftHand, unit * 0.055);
    _drawDumbbell(canvas, rightHand, unit * 0.055);
    _drawHead(canvas, headCenter, unit * 0.06);
    _drawJoints(canvas, [
      leftKnee,
      rightKnee,
      leftShoulder,
      rightShoulder,
      leftElbow,
      rightElbow,
    ], unit * 0.02);
  }

  void _paintLowerBodyLunge(
    Canvas canvas,
    double cx,
    double floorY,
    double unit,
    double wave,
  ) {
    // wave = 0 -> tall split stance; wave = 1 -> lowered lunge
    final drop = unit * 0.13 * wave;
    final hipCenter = Offset(cx - unit * 0.02, floorY - unit * 0.37 + drop);
    final shoulderCenter = Offset(
      hipCenter.dx + unit * 0.02,
      hipCenter.dy - unit * 0.22,
    );
    final headCenter = Offset(
      shoulderCenter.dx + unit * 0.01,
      shoulderCenter.dy - unit * 0.095,
    );

    final frontFoot = Offset(cx + unit * 0.17, floorY);
    final backFoot = Offset(cx - unit * 0.21, floorY - unit * 0.015);
    final frontKnee = Offset(
      cx + unit * (0.14 + 0.05 * wave),
      floorY - unit * (0.19 - 0.02 * wave),
    );
    final backKnee = Offset(
      cx - unit * (0.12 - 0.01 * wave),
      floorY - unit * (0.19 - 0.11 * wave),
    );

    final leftHand = Offset(
      shoulderCenter.dx - unit * 0.09,
      hipCenter.dy + unit * 0.03,
    );
    final rightHand = Offset(
      shoulderCenter.dx + unit * 0.11,
      hipCenter.dy + unit * 0.02,
    );

    // Subtle focus ring around the working front quad
    final focusPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Styles.accent.withValues(alpha: 0.25 + 0.4 * wave);
    canvas.drawCircle(frontKnee, unit * 0.075, focusPaint);

    _drawLimb(canvas, backFoot, backKnee, unit * 0.042);
    _drawLimb(canvas, backKnee, hipCenter, unit * 0.046);
    _drawLimb(canvas, frontFoot, frontKnee, unit * 0.044);
    _drawLimb(canvas, frontKnee, hipCenter, unit * 0.048);

    _drawLimb(canvas, hipCenter, shoulderCenter, unit * 0.068);
    _drawLimb(canvas, shoulderCenter, leftHand, unit * 0.032);
    _drawLimb(canvas, shoulderCenter, rightHand, unit * 0.032);
    _drawHead(canvas, headCenter, unit * 0.06);
    _drawJoints(canvas, [
      frontKnee,
      backKnee,
      hipCenter,
      shoulderCenter,
    ], unit * 0.022);
  }

  void _paintUpperBodyPress(
    Canvas canvas,
    double cx,
    double floorY,
    double unit,
    double wave,
  ) {
    // wave = 0 -> rack at shoulders; wave = 1 -> overhead press lockout
    final hipY = floorY - unit * 0.36;
    final shoulderY = hipY - unit * 0.23;
    final headCenter = Offset(cx, shoulderY - unit * 0.095);

    final leftFoot = Offset(cx - unit * 0.10, floorY);
    final rightFoot = Offset(cx + unit * 0.10, floorY);
    final leftKnee = Offset(cx - unit * 0.08, floorY - unit * 0.18);
    final rightKnee = Offset(cx + unit * 0.08, floorY - unit * 0.18);
    final leftHip = Offset(cx - unit * 0.055, hipY);
    final rightHip = Offset(cx + unit * 0.055, hipY);
    final leftShoulder = Offset(cx - unit * 0.10, shoulderY);
    final rightShoulder = Offset(cx + unit * 0.10, shoulderY);

    final pressOffset = unit * (0.04 + 0.24 * wave);
    final leftHand = Offset(cx - unit * (0.16 - 0.05 * wave), shoulderY - pressOffset);
    final rightHand = Offset(cx + unit * (0.16 - 0.05 * wave), shoulderY - pressOffset);
    final leftElbow = Offset(
      cx - unit * (0.19 - 0.04 * wave),
      shoulderY + unit * (0.03 - 0.14 * wave),
    );
    final rightElbow = Offset(
      cx + unit * (0.19 - 0.04 * wave),
      shoulderY + unit * (0.03 - 0.14 * wave),
    );

    // Motion arc guide trails above shoulders
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Styles.primaryLight.withValues(alpha: 0.28 + 0.25 * wave);
    canvas.drawLine(
      Offset(cx - unit * 0.16, shoulderY - unit * 0.05),
      Offset(cx - unit * 0.11, shoulderY - unit * 0.27),
      arcPaint,
    );
    canvas.drawLine(
      Offset(cx + unit * 0.16, shoulderY - unit * 0.05),
      Offset(cx + unit * 0.11, shoulderY - unit * 0.27),
      arcPaint,
    );

    _drawLimb(canvas, leftFoot, leftKnee, unit * 0.04);
    _drawLimb(canvas, leftKnee, leftHip, unit * 0.044);
    _drawLimb(canvas, rightFoot, rightKnee, unit * 0.04);
    _drawLimb(canvas, rightKnee, rightHip, unit * 0.044);
    _drawTorso(canvas, leftHip, rightHip, leftShoulder, rightShoulder, unit);
    _drawLimb(canvas, leftShoulder, leftElbow, unit * 0.036);
    _drawLimb(canvas, leftElbow, leftHand, unit * 0.034);
    _drawLimb(canvas, rightShoulder, rightElbow, unit * 0.036);
    _drawLimb(canvas, rightElbow, rightHand, unit * 0.034);

    _drawDumbbell(canvas, leftHand, unit * 0.06);
    _drawDumbbell(canvas, rightHand, unit * 0.06);
    _drawHead(canvas, headCenter, unit * 0.06);
    _drawJoints(canvas, [
      leftShoulder,
      rightShoulder,
      leftElbow,
      rightElbow,
    ], unit * 0.02);
  }

  void _paintCoreTuck(
    Canvas canvas,
    double cx,
    double floorY,
    double unit,
    double wave,
  ) {
    // Mat line
    final matY = floorY - unit * 0.03;
    final matPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.2
      ..color = Styles.borderGlow.withValues(alpha: 0.55);
    canvas.drawLine(
      Offset(cx - unit * 0.34, matY),
      Offset(cx + unit * 0.34, matY),
      matPaint,
    );

    // wave = 0 -> extended hollow hold; wave = 1 -> tucked V-up crunch
    final hip = Offset(cx - unit * 0.02, matY - unit * 0.045);
    final torsoAngle = 0.28 + 0.72 * wave; // radians above horizontal
    final torsoLen = unit * 0.23;
    final shoulder = Offset(
      hip.dx - math.cos(torsoAngle) * torsoLen,
      hip.dy - math.sin(torsoAngle) * torsoLen,
    );
    final headCenter = Offset(
      shoulder.dx - math.cos(torsoAngle + 0.15) * unit * 0.085,
      shoulder.dy - math.sin(torsoAngle + 0.15) * unit * 0.085,
    );

    final thighAngle = 0.22 + 0.85 * wave;
    final thighLen = unit * 0.19;
    final knee = Offset(
      hip.dx + math.cos(thighAngle) * thighLen,
      hip.dy - math.sin(thighAngle) * thighLen,
    );
    final foot = Offset(
      knee.dx + unit * (0.17 - 0.07 * wave),
      knee.dy + unit * (0.04 + 0.08 * wave),
    );

    final hand = Offset(
      shoulder.dx + unit * (0.11 + 0.09 * wave),
      shoulder.dy - unit * (0.02 - 0.04 * wave),
    );

    // Core activation ring around hip/abs
    final coreRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Styles.secondary.withValues(alpha: 0.25 + 0.45 * wave);
    canvas.drawCircle(
      Offset(hip.dx - unit * 0.04, hip.dy - unit * 0.06),
      unit * (0.07 + 0.02 * wave),
      coreRing,
    );

    _drawLimb(canvas, hip, shoulder, unit * 0.062);
    _drawLimb(canvas, hip, knee, unit * 0.046);
    _drawLimb(canvas, knee, foot, unit * 0.04);
    _drawLimb(canvas, shoulder, hand, unit * 0.032);
    _drawHead(canvas, headCenter, unit * 0.058);
    _drawJoints(canvas, [hip, shoulder, knee], unit * 0.022);
  }

  void _drawTorso(
    Canvas canvas,
    Offset leftHip,
    Offset rightHip,
    Offset leftShoulder,
    Offset rightShoulder,
    double unit,
  ) {
    final path = Path()
      ..moveTo(leftHip.dx, leftHip.dy)
      ..lineTo(leftShoulder.dx, leftShoulder.dy)
      ..lineTo(rightShoulder.dx, rightShoulder.dy)
      ..lineTo(rightHip.dx, rightHip.dy)
      ..close();

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.primary.withValues(alpha: 0.32)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.primary.withValues(alpha: 0.78);
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, unit * 0.012)
      ..color = Styles.primaryLight;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  void _drawLimb(Canvas canvas, Offset a, Offset b, double width) {
    final aura = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 1.9
      ..color = Styles.primary.withValues(alpha: 0.34)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final body = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..color = Styles.primaryLight;
    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 0.36
      ..color = Styles.textPrimary.withValues(alpha: 0.85);

    canvas.drawLine(a, b, aura);
    canvas.drawLine(a, b, body);
    canvas.drawLine(a, b, core);
  }

  void _drawDumbbell(Canvas canvas, Offset center, double width) {
    final barPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 0.28
      ..color = Styles.secondary;
    final platePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.accent;

    final left = Offset(center.dx - width * 0.55, center.dy);
    final right = Offset(center.dx + width * 0.55, center.dy);
    canvas.drawLine(left, right, barPaint);
    canvas.drawCircle(left, width * 0.26, platePaint);
    canvas.drawCircle(right, width * 0.26, platePaint);
  }

  void _drawHead(Canvas canvas, Offset center, double radius) {
    final aura = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.primary.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.secondary;
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Styles.textPrimary;

    canvas.drawCircle(center, radius * 1.35, aura);
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, rim);
  }

  void _drawJoints(Canvas canvas, List<Offset> points, double radius) {
    final jointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.textPrimary;
    final ringPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Styles.secondary;

    for (final point in points) {
      canvas.drawCircle(point, radius, ringPaint);
      canvas.drawCircle(point, radius * 0.55, jointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WorkoutFigurePainter oldDelegate) {
    return oldDelegate.motion != motion || oldDelegate.progress != progress;
  }
}
