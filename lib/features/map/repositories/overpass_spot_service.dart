import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';

class OverpassSpotService {
  static const _endpoint = 'https://overpass-api.de/api/interpreter';

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

    final res = await http
        .post(
          Uri.parse(_endpoint),
          headers: {'User-Agent': 'com.example.kelompok_strava_uas_moprog'},
          body: {'data': query},
        )
        .timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Overpass error ${res.statusCode}');
    }

    final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final elements = data['elements'] as List<dynamic>;
    return elements
        .map((e) => PlaceSpot.fromOverpass(e as Map<String, dynamic>))
        .whereType<PlaceSpot>()
        .toList();
  }
}