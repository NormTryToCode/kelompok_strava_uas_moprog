import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class PhotoCropOverlay extends StatelessWidget {
  final Rect cropRect;
  final bool isDragging;

  const PhotoCropOverlay({
    super.key,
    required this.cropRect,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CropOverlayPainter(
          cropRect: cropRect,
          isDragging: isDragging,
        ),
      ),
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final bool isDragging;

  const _CropOverlayPainter({
    required this.cropRect,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect fullRect = Offset.zero & size;
    final Path dimPath = Path()
      ..addRect(fullRect)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;

    final Paint dimPaint = Paint()
      ..color = const Color.fromARGB(145, 0, 0, 0)
      ..style = PaintingStyle.fill;

    canvas.drawPath(dimPath, dimPaint);

    final Paint gridPaint = Paint()
      ..color = isDragging
        ? const Color.fromARGB(200, 255, 255, 255)
        : const Color.fromARGB(140, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double thirdW = cropRect.width / 3;
    final double thirdH = cropRect.height / 3;

    canvas.drawLine(
      Offset(cropRect.left + thirdW, cropRect.top),
      Offset(cropRect.left + thirdW, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left + thirdW * 2, cropRect.top),
      Offset(cropRect.left + thirdW * 2, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdH),
      Offset(cropRect.right, cropRect.top + thirdH),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + thirdH * 2),
      Offset(cropRect.right, cropRect.top + thirdH * 2),
      gridPaint,
    );

    final Paint borderPaint = Paint()
      ..color = Styles.tabActive
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawRect(cropRect, borderPaint);

    final Paint cornerPaint = Paint()
      ..color = Styles.tabActive
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.square;

    const double inset = 5.0;
    const double length = 18.0;

    final double left = cropRect.left + inset;
    final double top = cropRect.top + inset;
    final double right = cropRect.right - inset;
    final double bottom = cropRect.bottom - inset;

    canvas.drawLine(Offset(left, top), Offset(left + length, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + length), cornerPaint);

    canvas.drawLine(
      Offset(right, top),
      Offset(right - length, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + length),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + length, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, bottom - length),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right - length, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - length),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CropOverlayPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect ||
        oldDelegate.isDragging != isDragging;
  }
}