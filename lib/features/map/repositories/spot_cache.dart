import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

class CachedSpots {
  final LatLng center;
  final DateTime savedAt;
  final List<PlaceSpot> spots;

  const CachedSpots({
    required this.center,
    required this.savedAt,
    required this.spots,
  });
}

class SpotCache {
  static const _key = 'overpass_spot_cache_v1';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<CachedSpots?> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CachedSpots(
        center: LatLng(
          (json['lat'] as num).toDouble(),
          (json['lng'] as num).toDouble(),
        ),
        savedAt: DateTime.parse(json['savedAt'] as String),
        spots: (json['spots'] as List<dynamic>)
            .map((e) => PlaceSpot.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      return null; // cache rusak: abaikan
    }
  }

  Future<void> save(LatLng center, List<PlaceSpot> spots) {
    return _prefs.setString(
      _key,
      jsonEncode({
        'lat': center.latitude,
        'lng': center.longitude,
        'savedAt': DateTime.now().toIso8601String(),
        'spots': spots.map((s) => s.toJson()).toList(),
      }),
    );
  }
}