import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class PaceRangeDraft {
  final int id;
  String min;
  String max;

  PaceRangeDraft({required this.id, required this.min, required this.max});

  double? get minValue => double.tryParse(min.trim());
  double? get maxValue => double.tryParse(max.trim());

  String? get error {
    final lo = minValue;
    final hi = maxValue;
    if (lo == null || hi == null) return 'Enter both values';
    if (hi <= lo) return 'Max must be higher than min';
    return null;
  }
}

class EventFormController extends ChangeNotifier {
  static const minNameLength = 3;
  static const maxNameLength = 125;
  static const maxPaceRanges = 6;
  static const maxCapacity = 100000;

  EventFormController() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    date = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
  }

  String name = '';
  ClubSport? sport = ClubSport.option.firstWhere((s) => s.id == 'running');
  bool skipSport = false;
  late DateTime date;
  TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
  bool recurring = false;
  bool monthly = false;
  bool monthlyByWeekday = false;
  int interval = 1;
  ClubLocation? location;
  bool isVirtual = false;
  String description = '';
  bool discoverable = true;

  EventKind? kind;
  bool paceEnabled = false;
  PaceUnit paceUnit = PaceUnit.kph;
  final List<PaceRangeDraft> paceRanges = [];
  int _nextPaceId = 0;

  String distance = '';
  DistanceUnit distanceUnit = DistanceUnit.km;
  EventSurface? surface;

  bool womenOnly = false;
  bool clubMembersOnly = true;
  bool capacityEnabled = false;
  String capacity = '';

  bool showErrors = false;

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  DateTime get startsAt =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  EventRecurrence? get recurrence => recurring
      ? EventRecurrence(
          isMonthly: monthly,
          interval: interval,
          monthlyByWeekday: monthly && monthlyByWeekday,
        )
      : null;

  String get recurrenceSummary => recurrence?.summary(startsAt) ?? '';

  void shiftToWeekday(int weekday) {
    final diff = (weekday - date.weekday + 7) % 7;
    update(() => date = DateTime(date.year, date.month, date.day + diff));
  }

  void setMonthly(bool value) {
    update(() {
      monthly = value;
      interval = 1;
      monthlyByWeekday = false;
    });
  }

  void setPaceEnabled(bool value) {
    update(() {
      paceEnabled = value;
      if (value && paceRanges.isEmpty) _addPaceRange();
    });
  }

  void addPaceRange() {
    if (paceRanges.length >= maxPaceRanges) return;
    update(_addPaceRange);
  }

  void _addPaceRange() {
    final start = paceRanges.isEmpty ? 0.0 : (paceRanges.last.maxValue ?? 0.0);
    paceRanges.add(PaceRangeDraft(
      id: _nextPaceId++,
      min: _formatPace(start),
      max: _formatPace(start + 10),
    ));
  }

  void removePaceRange(int id) {
    update(() => paceRanges.removeWhere((r) => r.id == id));
  }

  void setPaceUnit(PaceUnit unit) {
    if (unit == paceUnit) return;
    final factor = unit == PaceUnit.mph ? 1 / 1.609344 : 1.609344;
    update(() {
      for (final range in paceRanges) {
        final lo = range.minValue;
        final hi = range.maxValue;
        if (lo != null) range.min = _formatPace(lo * factor);
        if (hi != null) range.max = _formatPace(hi * factor);
      }
      paceUnit = unit;
    });
  }

  String _formatPace(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  String? get nameError {
    final length = name.trim().length;
    if (length < minNameLength || length > maxNameLength) {
      return 'Use $minNameLength to $maxNameLength characters';
    }
    return null;
  }

  String? get sportError =>
      (!skipSport && sport == null) ? 'Choose a sport' : null;

  String? get dateError =>
      startsAt.isBefore(DateTime.now()) ? 'Pick a future date and time' : null;

  String? get locationError =>
      (!isVirtual && location == null) ? 'Choose a meeting point' : null;

  String? get kindError => kind == null ? 'Choose an event type' : null;

  String? get paceError {
    if (!paceEnabled) return null;
    if (paceRanges.isEmpty) return 'Add at least one pace group';
    for (final range in paceRanges) {
      if (range.error != null) return range.error;
    }
    return null;
  }

  String? get distanceError {
    if (distance.trim().isEmpty) return null;
    final value = double.tryParse(distance.trim());
    return (value == null || value <= 0) ? 'Enter a valid distance' : null;
  }

  String? get capacityError {
    if (!capacityEnabled) return null;
    final value = int.tryParse(capacity.trim());
    if (value == null || value < 1 || value > maxCapacity) {
      return 'Enter a number from 1 to 100,000';
    }
    return null;
  }

  bool get isValid => [
        nameError,
        sportError,
        dateError,
        locationError,
        kindError,
        paceError,
        distanceError,
        capacityError,
      ].every((error) => error == null);

  Event buildEvent(Club club) {
    final now = DateTime.now();
    final distanceValue = double.tryParse(distance.trim());

    return Event(
      id: now.microsecondsSinceEpoch.toString(),
      clubId: club.id,
      clubName: club.name,
      name: name.trim(),
      sport: skipSport ? null : sport,
      startsAt: startsAt,
      recurrence: recurrence,
      isVirtual: isVirtual,
      location: isVirtual ? null : location,
      description: description.trim(),
      isDiscoverable: discoverable,
      kind: kind!,
      paceUnit: paceEnabled ? paceUnit : null,
      paceRanges: paceEnabled
          ? [
              for (final r in paceRanges)
                PaceRange(min: r.minValue!, max: r.maxValue!),
            ]
          : const [],
      distance: (distanceValue != null && distanceValue > 0)
          ? distanceValue
          : null,
      distanceUnit: distanceUnit,
      surface: surface,
      womenOnly: womenOnly,
      clubMembersOnly: clubMembersOnly,
      capacity: capacityEnabled ? int.tryParse(capacity.trim()) : null,
      attendeeCount: 1,
      createdAt: now,
    );
  }
}
