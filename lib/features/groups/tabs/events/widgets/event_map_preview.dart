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

  static const _darkNavyMapFilter = ColorFilter.matrix(<double>[
    -0.85,
    0,
    0,
    0,
    230,
    0,
    -0.82,
    0,
    0,
    236,
    0,
    0,
    -0.78,
    0,
    240,
    0,
    0,
    0,
    1,
    0,
  ]);

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
          backgroundColor: Styles.deepNavy,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.kelompok_strava_uas_moprog',
            maxNativeZoom: 19,
            tileBuilder: (_, tileWidget, _) => ColorFiltered(
              colorFilter: _darkNavyMapFilter,
              child: tileWidget,
            ),
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
                      color: Styles.marigold.withAlpha(55),
                      border: Border.all(color: Styles.gold, width: 1.6),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Styles.marigold,
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

