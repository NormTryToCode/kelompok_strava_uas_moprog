import 'package:latlong2/latlong.dart';

enum SpotType { run, bike }

class PlaceSpot {
  final String id;
  final String name;
  final SpotType type;
  final LatLng position;

  const PlaceSpot({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
  });

  factory PlaceSpot.fromJson(Map<String, dynamic> json) => PlaceSpot(
        id: json['id'] as String,
        name: json['name'] as String,
        type: SpotType.values.byName(json['type'] as String),
        position: LatLng(
          (json['lat'] as num).toDouble(),
          (json['lng'] as num).toDouble(),
        ),
  );
  static PlaceSpot? fromOverpass(Map<String, dynamic> e) {
    final tags = (e['tags'] as Map<String, dynamic>?) ?? {};
    final name = tags['name'] as String?;
    final center = e['center'] as Map<String, dynamic>?;
    final lat = (e['lat'] ?? center?['lat']) as num?;
    final lon = (e['lon'] ?? center?['lon']) as num?;
    if (name == null || lat == null || lon == null) return null;

    final isBike = tags['highway'] == 'cycleway' || tags['route'] == 'bicycle';
    return PlaceSpot(
      id: '${e['type']}_${e['id']}',
      name: name,
      type: isBike ? SpotType.bike : SpotType.run,
      position: LatLng(lat.toDouble(), lon.toDouble()),
    );
  }
}