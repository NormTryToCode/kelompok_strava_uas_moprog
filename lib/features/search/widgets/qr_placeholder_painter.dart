import 'package:flutter/material.dart';

class QrPlaceholderPainter extends CustomPainter {
  final String seed;
  final int modules;

  const QrPlaceholderPainter({required this.seed, this.modules = 25});

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / modules;
    final dark = Paint()..color = Colors.black;
    final light = Paint()..color = Colors.white;
    var state =
        seed.codeUnits.fold<int>(7, (h, c) => (h * 31 + c) & 0x7fffffff);

    for (var row = 0; row < modules; row++) {
      for (var col = 0; col < modules; col++) {
        state = (state * 1664525 + 1013904223) & 0xFFFFFFFF;
        if (_isFinderZone(row, col)) continue;
        if ((state >> 16).isOdd) {
          canvas.drawRect(
            Rect.fromLTWH(col * cell, row * cell, cell, cell),
            dark,
          );
        }
      }
    }

    _drawFinder(canvas, cell, 0, 0, dark, light);
    _drawFinder(canvas, cell, 0, modules - 7, dark, light);
    _drawFinder(canvas, cell, modules - 7, 0, dark, light);
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
    Paint dark,
    Paint light,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(col * cell, row * cell, 7 * cell, 7 * cell),
      dark,
    );
    canvas.drawRect(
      Rect.fromLTWH((col + 1) * cell, (row + 1) * cell, 5 * cell, 5 * cell),
      light,
    );
    canvas.drawRect(
      Rect.fromLTWH((col + 2) * cell, (row + 2) * cell, 3 * cell, 3 * cell),
      dark,
    );
  }

  @override
  bool shouldRepaint(QrPlaceholderPainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.modules != modules;
  }
}