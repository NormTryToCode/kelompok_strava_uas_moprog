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
    this.height = 176,
    this.zoom = 15,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    Widget map = SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: point,
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.kelompok_strava_uas_moprog',
                maxNativeZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: point,
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Styles.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Styles.background.withAlpha(45),
              ),
            ),
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