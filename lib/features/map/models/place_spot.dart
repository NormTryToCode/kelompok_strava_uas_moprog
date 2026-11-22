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
}