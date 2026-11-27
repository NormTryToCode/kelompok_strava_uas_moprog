/// Immutable daily activity metrics for a single weekday in a weekly summary.
class DailyActivityEntry {
  final int dayIndex;
  final String dayLabel;
  final String dateIso;
  final double distanceKm;
  final int calories;
  final int steps;

  const DailyActivityEntry({
    required this.dayIndex,
    required this.dayLabel,
    required this.dateIso,
    required this.distanceKm,
    required this.calories,
    required this.steps,
  });

  double get stepsInThousands => steps / 1000.0;

  bool get hasActivity => distanceKm > 0 || calories > 0 || steps > 0;

  DailyActivityEntry copyWith({
    int? dayIndex,
    String? dayLabel,
    String? dateIso,
    double? distanceKm,
    int? calories,
    int? steps,
  }) {
    return DailyActivityEntry(
      dayIndex: dayIndex ?? this.dayIndex,
      dayLabel: dayLabel ?? this.dayLabel,
      dateIso: dateIso ?? this.dateIso,
      distanceKm: distanceKm ?? this.distanceKm,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
    );
  }

  /// Returns a new entry with [distanceKm], [calories], and [steps] added.
  DailyActivityEntry addMetrics({
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
  }) {
    final nextDistance = double.parse(
      (this.distanceKm + distanceKm).clamp(0.0, double.infinity).toStringAsFixed(2),
    );
    final nextCalories = this.calories + calories;
    final nextSteps = this.steps + steps;

    return copyWith(
      distanceKm: nextDistance,
      calories: nextCalories < 0 ? 0 : nextCalories,
      steps: nextSteps < 0 ? 0 : nextSteps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayIndex': dayIndex,
      'dayLabel': dayLabel,
      'date': dateIso,
      'distanceKm': distanceKm,
      'calories': calories,
      'steps': steps,
    };
  }

  factory DailyActivityEntry.fromJson(
    Map<String, dynamic> json, {
    int fallbackIndex = 0,
  }) {
    final rawIndex = (json['dayIndex'] as num?)?.toInt() ?? fallbackIndex;
    final safeIndex = rawIndex.clamp(0, 6);
    final rawLabel = (json['dayLabel'] as String?)?.trim() ?? '';
    final rawDistance = (json['distanceKm'] as num?)?.toDouble() ?? 0.0;
    final rawCalories = (json['calories'] as num?)?.toInt() ?? 0;
    final rawSteps = (json['steps'] as num?)?.toInt() ?? 0;

    return DailyActivityEntry(
      dayIndex: safeIndex,
      dayLabel: rawLabel.isNotEmpty
          ? rawLabel
          : WeeklyActivityData.weekdayLabels[safeIndex],
      dateIso: (json['date'] as String?)?.trim() ?? '',
      distanceKm: rawDistance < 0
          ? 0.0
          : double.parse(rawDistance.toStringAsFixed(2)),
      calories: rawCalories < 0 ? 0 : rawCalories,
      steps: rawSteps < 0 ? 0 : rawSteps,
    );
  }
}

/// Weekly activity summary storing Mon–Sun distance, calories, and steps.
class WeeklyActivityData {
  static const List<String> weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final String id;
  final String userId;
  final String weekStartDate;
  final List<DailyActivityEntry> days;
  final bool isSeeded;
  final DateTime updatedAt;

  const WeeklyActivityData({
    required this.id,
    required this.userId,
    required this.weekStartDate,
    required this.days,
    required this.isSeeded,
    required this.updatedAt,
  });

  static DateTime mondayOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  static String formatDateIso(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String buildDocId({
    required String userId,
    required DateTime referenceDate,
  }) {
    return '${userId}_${formatDateIso(mondayOfWeek(referenceDate))}';
  }

  factory WeeklyActivityData.empty({
    required String userId,
    required DateTime referenceDate,
    bool isSeeded = false,
  }) {
    final monday = mondayOfWeek(referenceDate);
    final weekStart = formatDateIso(monday);
    final docId = '${userId}_$weekStart';

    final entries = List<DailyActivityEntry>.generate(7, (index) {
      final dayDate = DateTime(monday.year, monday.month, monday.day + index);
      return DailyActivityEntry(
        dayIndex: index,
        dayLabel: weekdayLabels[index],
        dateIso: formatDateIso(dayDate),
        distanceKm: 0.0,
        calories: 0,
        steps: 0,
      );
    });

    return WeeklyActivityData(
      id: docId,
      userId: userId,
      weekStartDate: weekStart,
      days: List.unmodifiable(entries),
      isSeeded: isSeeded,
      updatedAt: DateTime.now(),
    );
  }

  double get totalDistanceKm {
    final sum = days.fold<double>(0.0, (acc, d) => acc + d.distanceKm);
    return double.parse(sum.toStringAsFixed(2));
  }

  int get totalCalories => days.fold<int>(0, (acc, d) => acc + d.calories);

  int get totalSteps => days.fold<int>(0, (acc, d) => acc + d.steps);

  double get totalStepsInThousands => totalSteps / 1000.0;

  int get activeDaysCount => days.where((d) => d.hasActivity).length;

  List<double> get distanceSeries => [for (final d in days) d.distanceKm];

  List<double> get caloriesSeries =>
      [for (final d in days) d.calories.toDouble()];

  List<double> get stepsThousandsSeries =>
      [for (final d in days) d.stepsInThousands];

  DailyActivityEntry entryForWeekday(int weekday) {
    final index = (weekday - 1).clamp(0, 6);
    return days[index];
  }

  WeeklyActivityData copyWith({
    String? id,
    String? userId,
    String? weekStartDate,
    List<DailyActivityEntry>? days,
    bool? isSeeded,
    DateTime? updatedAt,
  }) {
    return WeeklyActivityData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      days: days != null ? List.unmodifiable(days) : this.days,
      isSeeded: isSeeded ?? this.isSeeded,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Accumulates recorded metrics into the weekday entry matching [date].
  WeeklyActivityData withAddedMetrics({
    required DateTime date,
    double distanceKm = 0,
    int calories = 0,
    int steps = 0,
    bool markUnseeded = true,
  }) {
    final targetIndex = (date.weekday - 1).clamp(0, 6);
    final updatedDays = [
      for (int i = 0; i < days.length; i++)
        i == targetIndex
            ? days[i].addMetrics(
                distanceKm: distanceKm,
                calories: calories,
                steps: steps,
              )
            : days[i],
    ];

    return copyWith(
      days: updatedDays,
      isSeeded: markUnseeded ? false : isSeeded,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'weekStartDate': weekStartDate,
      'isSeeded': isSeeded,
      'updatedAt': updatedAt.toIso8601String(),
      'totalDistanceKm': totalDistanceKm,
      'totalCalories': totalCalories,
      'totalSteps': totalSteps,
      'days': [for (final day in days) day.toJson()],
    };
  }

  factory WeeklyActivityData.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    final resolvedUserId = (json['userId'] as String?)?.trim() ?? '';
    final rawWeekStart = (json['weekStartDate'] as String?)?.trim() ?? '';
    final parsedMonday = DateTime.tryParse(rawWeekStart) ?? mondayOfWeek(DateTime.now());
    final base = WeeklyActivityData.empty(
      userId: resolvedUserId,
      referenceDate: parsedMonday,
      isSeeded: json['isSeeded'] as bool? ?? false,
    );

    final normalizedDays = List<DailyActivityEntry>.from(base.days);
    final rawDays = json['days'];
    if (rawDays is List) {
      for (int i = 0; i < rawDays.length; i++) {
        final item = rawDays[i];
        if (item is Map) {
          final parsed = DailyActivityEntry.fromJson(
            Map<String, dynamic>.from(item),
            fallbackIndex: i,
          );
          final defaultDay = normalizedDays[parsed.dayIndex];
          normalizedDays[parsed.dayIndex] = parsed.copyWith(
            dateIso: parsed.dateIso.isNotEmpty ? parsed.dateIso : defaultDay.dateIso,
          );
        }
      }
    }

    final rawUpdatedAt = json['updatedAt'];
    DateTime updatedAt = DateTime.now();
    if (rawUpdatedAt is String) {
      updatedAt = DateTime.tryParse(rawUpdatedAt) ?? updatedAt;
    }

    return WeeklyActivityData(
      id: id ?? (json['id'] as String?) ?? base.id,
      userId: resolvedUserId,
      weekStartDate: rawWeekStart.isNotEmpty ? rawWeekStart : base.weekStartDate,
      days: List.unmodifiable(normalizedDays),
      isSeeded: json['isSeeded'] as bool? ?? false,
      updatedAt: updatedAt,
    );
  }
}
