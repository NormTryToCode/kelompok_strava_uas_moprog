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
    final raw = await rootBundle.loadString('asset/spots.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => PlaceSpot.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}