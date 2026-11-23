const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60);
  final seconds = value.inSeconds.remainder(60);
  final mm = minutes.toString().padLeft(2, '0');
  final ss = seconds.toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$mm:$ss' : '$minutes:$ss';
}

String formatDistance(double km) {
  var text = km.toStringAsFixed(2);
  text = text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  return '$text km';
}

String formatPace(Duration pace) => '${formatDuration(pace)} /km';

String formatDate(DateTime date) {
  return '${date.day} ${_months[date.month - 1]} ${date.year}';
}

Duration? parseDuration(String input) {
  final text = input.trim();
  if (text.isEmpty) return null;

  final parts = text.split(':');
  if (parts.length > 3) return null;

  final numbers = <int>[];
  for (final part in parts) {
    final value = int.tryParse(part.trim());
    if (value == null || value < 0) return null;
    numbers.add(value);
  }

  var hours = 0;
  var minutes = 0;
  var seconds = 0;
  switch (numbers.length) {
    case 1:
      minutes = numbers[0];
    case 2:
      hours = numbers[0];
      minutes = numbers[1];
    default:
      hours = numbers[0];
      minutes = numbers[1];
      seconds = numbers[2];
  }

  if (numbers.length > 1 && minutes >= 60) return null;
  if (numbers.length == 3 && seconds >= 60) return null;

  final result = Duration(hours: hours, minutes: minutes, seconds: seconds);
  return result == Duration.zero ? null : result;
}

double? parseDistance(String input) {
  final value = double.tryParse(input.trim().replaceAll(',', '.'));
  if (value == null || value.isNaN || value <= 0 || value > 1000) return null;
  return value;
}