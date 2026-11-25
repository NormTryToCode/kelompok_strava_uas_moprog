import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';
import 'package:flutter/foundation.dart';

class OverpassSpotService {
  static const _endpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.private.coffee/api/interpreter',
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
  ];

  Future<List<PlaceSpot>> fetchNearby(LatLng center, {int radius = 3000}) async {
    final lat = center.latitude;
    final lng = center.longitude;
    final query = '''
[out:json][timeout:15];
(
  nwr(around:$radius,$lat,$lng)["leisure"~"park|track"]["name"];
  nwr(around:$radius,$lat,$lng)["highway"="cycleway"]["name"];
);
out center 40;
''';

    Object? lastError;
    for (final endpoint in _endpoints) {
            final sw = Stopwatch()..start();
      try {
        final res = await http
            .post(
              Uri.parse(endpoint),
              headers: {
                'User-Agent':
                    'StrideMobprog/1.0 (student UAS project; contact: emailkamu@contoh.com)',
                'Accept': '*/*',
              },
              body: {'data': query},
            )
            .timeout(const Duration(seconds: 12));

        debugPrint('Overpass $endpoint -> ${res.statusCode} in ${sw.elapsed}');
        if (res.statusCode != 200) {
          lastError = 'HTTP ${res.statusCode} from $endpoint';
          continue;
        }
        // ...parsing seperti sebelumnya
      } catch (e) {
        lastError = e;
        debugPrint('Overpass $endpoint failed after ${sw.elapsed}: $e');
      }
      try {
        final res = await http
            .post(
              Uri.parse(endpoint),
              headers: {'User-Agent': 'com.example.kelompok_strava_uas_moprog'},
              body: {'data': query},
            )
            .timeout(const Duration(seconds: 20));

        if (res.statusCode != 200) {
          lastError = 'HTTP ${res.statusCode} from $endpoint';
          continue; // coba server berikutnya
        }

        final data =
            jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final elements = data['elements'] as List<dynamic>;
        return elements
            .map((e) => PlaceSpot.fromOverpass(e as Map<String, dynamic>))
            .whereType<PlaceSpot>()
            .toList();
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('All Overpass endpoints failed: $lastError');
  }
}