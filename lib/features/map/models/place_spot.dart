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
  
  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'type': type.name,
      'lat': position.latitude,
      'lng': position.longitude,
    };


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

    final cycleway = tags['cycleway'] ??
        tags['cycleway:right'] ??
        tags['cycleway:left'] ??
        tags['cycleway:both'];
    final isBike = tags['highway'] == 'cycleway' ||
        tags['route'] == 'bicycle' ||
        cycleway == 'lane' ||
        cycleway == 'track';
    final leisure = tags['leisure'];
    if (!isBike && leisure != 'park' && leisure != 'track') return null;
    return PlaceSpot(
      id: '${e['type']}_${e['id']}',
      name: name,
      type: isBike ? SpotType.bike : SpotType.run,
      position: LatLng(lat.toDouble(), lon.toDouble()),
    );
  }
}