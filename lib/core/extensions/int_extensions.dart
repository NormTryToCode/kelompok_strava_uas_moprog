extension CountFormat on int {
  String get withThousands {
    final digits = abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return this < 0 ? '-$buffer' : buffer.toString();
  }
}