import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:latlong2/latlong.dart';

class EventMapPreview extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double height;
  final double zoom;
  final BorderRadius? borderRadius;

  const EventMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 190,
    this.zoom = 15,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    Widget map = SizedBox(
      height: height,
      width: double.infinity,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: zoom,
          backgroundColor: Styles.surface,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
            userAgentPackageName: 'com.example.kelompok_strava_uas_moprog',
            maxNativeZoom: 19,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 48,
                height: 48,
                child: Center(
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.teal.withAlpha(42),
                      border: Border.all(
                        color: Palette.teal.withAlpha(180),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Palette.teal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (borderRadius != null) {
      map = ClipRRect(borderRadius: borderRadius!, child: map);
    }
    return map;
  }
}