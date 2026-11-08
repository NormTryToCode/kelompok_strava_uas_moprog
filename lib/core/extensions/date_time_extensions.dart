extension TimeAgo on DateTime {
  String timeAgo({DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(this);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return _unit(diff.inMinutes, 'minute');
    if (diff.inHours < 24) return _unit(diff.inHours, 'hour');
    if (diff.inDays < 30) return _unit(diff.inDays, 'day');
    return _unit(diff.inDays ~/ 30, 'month');
  }
}

String _unit(int value, String name) {
  return '$value $name${value == 1 ? '' : 's'} ago';
}