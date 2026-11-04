import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  LatLng? _userPosition;

  Future<void> _locate() async {
    // GPS harus nyala
    if (!await Geolocator.isLocationServiceEnabled()) {
      _showMessage('Aktifkan GPS dulu');
      return;
    }
    
    // Ada izin pemakaian lokasi
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Izin lokasi ditolak');
      return;
    }

    
    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    final latLng = LatLng(pos.latitude, pos.longitude);
    setState(() => _userPosition = latLng);
    _mapController.move(latLng, 16);
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(-6.2088, 106.8456),
        initialZoom: 14,
        onMapReady: _locate,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.kelompok_strava_uas_moprog',
        ),
      ],
    );
  }
}