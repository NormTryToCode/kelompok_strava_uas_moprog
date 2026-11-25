import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

abstract class SpotRepository {
  static SpotRepository instance = AssetSpotRepository();

  Future<List<PlaceSpot>> getSpots();
}

class AssetSpotRepository implements SpotRepository {
  @override
  Future<List<PlaceSpot>> getSpots() async {
    final raw = await rootBundle.loadString('asset/overpass_snapshot.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final elements = data['elements'] as List<dynamic>;
        final spots = elements
        .map((e) => PlaceSpot.fromOverpass(e as Map<String, dynamic>))
        .whereType<PlaceSpot>()
        .toList();

    final seen = <String>{};
    return spots.where((s) => seen.add('${s.type.name}:${s.name}')).toList();
  }
}