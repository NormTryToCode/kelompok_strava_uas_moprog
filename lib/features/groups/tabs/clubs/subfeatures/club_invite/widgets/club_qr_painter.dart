import 'package:flutter/material.dart';

class ClubQrPainter extends CustomPainter {
  final String seed;
  final Color foregroundColor;
  final Color backgroundColor;
  final int modules;

  const ClubQrPainter({
    required this.seed,
    required this.foregroundColor,
    required this.backgroundColor,
    this.modules = 25,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / modules;
    final fg = Paint()..color = foregroundColor;
    final bg = Paint()..color = backgroundColor;

    var state =
        seed.codeUnits.fold<int>(17, (h, c) => (h * 31 + c) & 0x7fffffff);

    final centerMin = (modules ~/ 2) - 3;
    final centerMax = (modules ~/ 2) + 3;

    for (var row = 0; row < modules; row++) {
      for (var col = 0; col < modules; col++) {
        state = (state * 1664525 + 1013904223) & 0xFFFFFFFF;
        if (_isFinderZone(row, col)) continue;
        if (row >= centerMin &&
            row <= centerMax &&
            col >= centerMin &&
            col <= centerMax) {
          continue;
        }
        if ((state >> 16).isOdd) {
          canvas.drawRect(
            Rect.fromLTWH(col * cell, row * cell, cell, cell),
            fg,
          );
        }
      }
    }

    _drawFinder(canvas, cell, 0, 0, fg, bg);
    _drawFinder(canvas, cell, 0, modules - 7, fg, bg);
    _drawFinder(canvas, cell, modules - 7, 0, fg, bg);
  }

  bool _isFinderZone(int row, int col) {
    final top = row < 8;
    final bottom = row >= modules - 8;
    final left = col < 8;
    final right = col >= modules - 8;
    return (top && left) || (top && right) || (bottom && left);
  }

  void _drawFinder(
    Canvas canvas,
    double cell,
    int row,
    int col,
    Paint fg,
    Paint bg,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(col * cell, row * cell, 7 * cell, 7 * cell),
      fg,
    );
    canvas.drawRect(
      Rect.fromLTWH((col + 1) * cell, (row + 1) * cell, 5 * cell, 5 * cell),
      bg,
    );
    canvas.drawRect(
      Rect.fromLTWH((col + 2) * cell, (row + 2) * cell, 3 * cell, 3 * cell),
      fg,
    );
  }

  @override
  bool shouldRepaint(ClubQrPainter oldDelegate) {
    return oldDelegate.seed != seed ||
        oldDelegate.foregroundColor != foregroundColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.modules != modules;
  }
}