import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/user_location_marker.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/my_location_button.dart';
import 'package:kelompok_strava_uas_moprog/features/map/models/place_spot.dart';
import 'package:kelompok_strava_uas_moprog/features/map/repositories/spot_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/spot_marker.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/spot_card.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/spot_filter_bar.dart';
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

  List<PlaceSpot> _spots = [];
    SpotType? _filter; // null = semua

  double? _distanceTo(PlaceSpot spot) {
    final user = _userPosition;
    if (user == null) return null;
    return const Distance().as(LengthUnit.Meter, user, spot.position);
  }

  List<PlaceSpot> get _visibleSpots {
    final spots =
        _spots.where((s) => _filter == null || s.type == _filter).toList();
    if (_userPosition != null) {
      spots.sort((a, b) => _distanceTo(a)!.compareTo(_distanceTo(b)!));
    }
    return spots;
  }

  void _focusSpot(PlaceSpot spot) {
    setState(() => _follow = false);
    _mapController.move(spot.position, 16);
  }

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    final spots = await SpotRepository.instance.getSpots();
    if (!mounted) return;
    setState(() => _spots = spots);
  }

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
    final spots = _visibleSpots;
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
            MarkerLayer(
              markers: [
                for (final s in spots)
                  Marker(
                    point: s.position,
                    width: 36,
                    height: 36,
                    child: SpotMarker(type: s.type),
                  ),
              ],
            ),
            if (_userPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userPosition!,
                    width: 48,
                    height: 48,
                    child: const UserLocationMarker(),
                  ),
                ],
              ),
          ],
        ),
                Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: SpotFilterBar(
            selected: _filter,
            onChanged: (type) => setState(() => _filter = type),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: spots.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => SizedBox(
                width: 220,
                child: SpotCard(
                  spot: spots[i],
                  distanceMeters: _distanceTo(spots[i]),
                  onTap: () => _focusSpot(spots[i]),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 108,
          child: MyLocationButton(following: _follow, onPressed: _recenter),
        ),
      ],
    );
  }
}