import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  LatLng? _userPosition;
  StreamSubscription<Position>? _positionSub;
  bool _follow = true;

  Future<bool> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _showMessage('Aktifkan GPS dulu');
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Izin lokasi ditolak');
      return false;
    }
    return true;
  }

  Future<void> _startTracking() async {
    if (_positionSub != null) return;
    if (!await _ensurePermission()) return;

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen(
      (pos) {
        if (!mounted) return;
        final latLng = LatLng(pos.latitude, pos.longitude);
        setState(() => _userPosition = latLng);
        if (_follow) {
          _mapController.move(latLng, _mapController.camera.zoom);
        }
      },
      onError: (e) {
        _positionSub?.cancel();
        _positionSub = null;
        _showMessage('Gagal ambil lokasi: $e');
      },
    );
  }

  void _recenter() {
    if (_userPosition == null) {
      _startTracking();
      return;
    }
    setState(() => _follow = true);
    _mapController.move(_userPosition!, 16);
  }
  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(-6.2088, 106.8456),
            initialZoom: 14,
            onMapReady: _startTracking,
            onPositionChanged: (camera, hasGesture) {
              if (hasGesture && _follow) setState(() => _follow = false);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.kelompok_strava_uas_moprog',
              maxNativeZoom: 19,
            ),
            if (_userPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userPosition!,
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0x402196F3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // titik utama
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 6),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: Styles.accent,
            onPressed: _recenter,
            child: Icon(
              _follow ? Icons.my_location : Icons.location_searching,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}