import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:latlong2/latlong.dart';

enum EventDateFilter { today, days7, days30, custom }

enum EventLocationFilter { nearMe, virtual, city }

class EventFilter {
  static const double maxDistanceLimit = 160;
  static const LatLng _defaultReferencePoint = LatLng(-6.2088, 106.8456);

  final ClubSport? sport;
  final EventDateFilter? dateFilter;
  final DateTime? customStart;
  final DateTime? customEnd;
  final EventLocationFilter? locationFilter;
  final String? pickedCity;
  final EventKind? format;
  final double minDistanceKm;
  final double maxDistanceKm;

  const EventFilter({
    this.sport,
    this.dateFilter,
    this.customStart,
    this.customEnd,
    this.locationFilter,
    this.pickedCity,
    this.format,
    this.minDistanceKm = 0,
    this.maxDistanceKm = maxDistanceLimit,
  });

  bool get hasDistanceFilter =>
      minDistanceKm > 0 || maxDistanceKm < maxDistanceLimit;

  int get activeFilterCount {
    var count = 0;
    if (dateFilter != null) count++;
    if (locationFilter != null) count++;
    if (format != null) count++;
    if (hasDistanceFilter) count++;
    return count;
  }

  bool get isFiltered => sport != null || activeFilterCount > 0;

  EventFilter copyWith({
    ClubSport? sport,
    bool clearSport = false,
    EventDateFilter? dateFilter,
    bool clearDate = false,
    DateTime? customStart,
    DateTime? customEnd,
    EventLocationFilter? locationFilter,
    bool clearLocation = false,
    String? pickedCity,
    bool clearPickedCity = false,
    EventKind? format,
    bool clearFormat = false,
    double? minDistanceKm,
    double? maxDistanceKm,
  }) {
    return EventFilter(
      sport: clearSport ? null : (sport ?? this.sport),
      dateFilter: clearDate ? null : (dateFilter ?? this.dateFilter),
      customStart: clearDate ? null : (customStart ?? this.customStart),
      customEnd: clearDate ? null : (customEnd ?? this.customEnd),
      locationFilter:
          clearLocation ? null : (locationFilter ?? this.locationFilter),
      pickedCity: clearLocation || clearPickedCity
          ? null
          : (pickedCity ?? this.pickedCity),
      format: clearFormat ? null : (format ?? this.format),
      minDistanceKm: minDistanceKm ?? this.minDistanceKm,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }

  EventFilter resetSecondaryFilters() {
    return EventFilter(sport: sport);
  }

  List<Event> apply(List<Event> events, {DateTime? now}) {
    final referenceNow = now ?? DateTime.now();
    const distanceCalc = Distance();

    return events.where((event) {
      if (sport != null && sport!.id != ClubSport.allSports.id) {
        if (event.sport?.id != sport!.id) return false;
      }

      if (dateFilter != null && !_matchesDate(event.startsAt, referenceNow)) {
        return false;
      }

      if (locationFilter != null &&
          !_matchesLocation(event, distanceCalc)) {
        return false;
      }

      if (format != null && event.kind.id != format!.id) {
        return false;
      }

      if (hasDistanceFilter) {
        final d = event.distance;
        if (d == null) return false;
        final km = event.distanceUnit == DistanceUnit.mi ? d * 1.609344 : d;
        if (km < minDistanceKm || km > maxDistanceKm) return false;
      }

      return true;
    }).toList();
  }

  bool _matchesDate(DateTime eventDate, DateTime now) {
    final startOfToday = DateTime(now.year, now.month, now.day);
    switch (dateFilter!) {
      case EventDateFilter.today:
        final endOfToday = startOfToday.add(const Duration(days: 1));
        return !eventDate.isBefore(startOfToday) &&
            eventDate.isBefore(endOfToday);
      case EventDateFilter.days7:
        final end = startOfToday.add(const Duration(days: 7));
        return !eventDate.isBefore(startOfToday) && !eventDate.isAfter(end);
      case EventDateFilter.days30:
        final end = startOfToday.add(const Duration(days: 30));
        return !eventDate.isBefore(startOfToday) && !eventDate.isAfter(end);
      case EventDateFilter.custom:
        if (customStart == null || customEnd == null) return true;
        final start = DateTime(
          customStart!.year,
          customStart!.month,
          customStart!.day,
        );
        final end = DateTime(
          customEnd!.year,
          customEnd!.month,
          customEnd!.day,
          23,
          59,
          59,
        );
        return !eventDate.isBefore(start) && !eventDate.isAfter(end);
    }
  }

  bool _matchesLocation(Event event, Distance distanceCalc) {
    switch (locationFilter!) {
      case EventLocationFilter.virtual:
        return event.isVirtual;
      case EventLocationFilter.nearMe:
        if (event.isVirtual) return false;
        final lat = event.location?.latitude;
        final lng = event.location?.longitude;
        if (lat == null || lng == null) return false;
        final km = distanceCalc.as(
          LengthUnit.Kilometer,
          _defaultReferencePoint,
          LatLng(lat, lng),
        );
        return km <= 60;
      case EventLocationFilter.city:
        final needle = pickedCity?.trim().toLowerCase() ?? '';
        if (needle.isEmpty) return true;
        final name = event.location?.name.toLowerCase() ?? '';
        final detail = event.location?.detail.toLowerCase() ?? '';
        return name.contains(needle) || detail.contains(needle);
    }
  }
}