import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

class OverpassSpotService {
  static const _endpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.private.coffee/api/interpreter',
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
  ];
  static const _retryableStatus = {429, 502, 503, 504};
  static const _userAgent =
      'StrideMobprog/1.0 (student UAS project; contact: emailkamu@contoh.com)';

  final _random = Random();

  Future<http.Response> _postWithBackoff(String endpoint, String query) async {
    const maxAttempts = 3;
    var delay = const Duration(seconds: 1);

    for (var attempt = 1; ; attempt++) {
      final res = await http
          .post(
            Uri.parse(endpoint),
            headers: {'User-Agent': _userAgent, 'Accept': '*/*'},
            body: {'data': query},
          )
          .timeout(const Duration(seconds: 20));

      if (!_retryableStatus.contains(res.statusCode) ||
          attempt == maxAttempts) {
        return res;
      }

      final retryAfter = int.tryParse(res.headers['retry-after'] ?? '');
      final wait = retryAfter != null
          ? Duration(seconds: min(retryAfter, 10))
          : delay;
      debugPrint('Overpass ${res.statusCode}, retry $attempt in $wait');
      await Future.delayed(wait + Duration(milliseconds: _random.nextInt(400)));
      delay *= 2;
    }
  }

  Future<List<PlaceSpot>> fetchNearby(LatLng center, {int radius = 8000}) async {
    final lat = center.latitude;
    final lng = center.longitude;
    final query = '''
[out:json][timeout:20];
(
  nwr(around:$radius,$lat,$lng)["leisure"~"park|track"]["name"];
  nwr(around:$radius,$lat,$lng)["highway"="cycleway"]["name"];
);
out center 100;
''';

    Object? lastError;
    for (final endpoint in _endpoints) {
      final sw = Stopwatch()..start();
      try {
        final res = await _postWithBackoff(endpoint, query);
        debugPrint('Overpass $endpoint -> ${res.statusCode} in ${sw.elapsed}');
        if (res.statusCode != 200) {
          lastError = 'HTTP ${res.statusCode} from $endpoint';
          continue;
        }

        final data =
            jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        final elements = data['elements'] as List<dynamic>;
        final spots = elements
            .map((e) => PlaceSpot.fromOverpass(e as Map<String, dynamic>))
            .whereType<PlaceSpot>()
            .toList();
        debugPrint('Overpass parsed ${spots.length} spots from $endpoint');
        return spots;
      } catch (e) {
        lastError = e;
        debugPrint('Overpass $endpoint failed after ${sw.elapsed}: $e');
      }
    }
    throw Exception('All Overpass endpoints failed: $lastError');
  }
}