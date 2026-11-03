import 'package:flutter/material.dart';

extension Gradient on List<Color> {
  Decoration toBottom() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: this,
      ),
    );
  }
}
