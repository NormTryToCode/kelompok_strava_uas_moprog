import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/map/widgets/user_location_marker.dart';
import 'package:kelompok_strava_uas_moprog/features/record/models/record_sport_catalog.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/map_overlay_sheets.dart';
import 'package:kelompok_strava_uas_moprog/features/record/widgets/sport_filter_sheet.dart';
import 'package:latlong2/latlong.dart';

/// Live activity recording framework screen with map, telemetry bar, and resizable controls.
class RecordTrackPage extends StatefulWidget {
  final String initialSportName;
  final bool autoStart;
  final bool enableLiveLocation;
  final WidgetBuilder? mapOverride;

  const RecordTrackPage({
    super.key,
    this.initialSportName = 'Run',
    this.autoStart = false,
    this.enableLiveLocation = true,
    this.mapOverride,
  });

  @override
  State<RecordTrackPage> createState() => _RecordTrackPageState();
}

class _RecordTrackPageState extends State<RecordTrackPage> {
  static const double _collapsedFraction = 0.34;
  static const double _expandedFraction = 0.70;
  static const double _telemetryBarHeight = 84.0;

  final MapController _mapController = MapController();
  LatLng? _userPosition;
  StreamSubscription<Position>? _positionSub;
  bool _follow = true;

  late RecordSportItem _selectedSport;
  late bool _isRecording;
  bool _isTelemetryFullScreen = false;
  double _sheetFraction = _collapsedFraction;

  @override
  void initState() {
    super.initState();
    _selectedSport = RecordSportCatalog.byName(widget.initialSportName);
    _isRecording = widget.autoStart;
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<bool> _ensurePermission() async {
    try {
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
    } catch (_) {
      return false;
    }
  }

  Future<void> _startTracking() async {
    if (!widget.enableLiveLocation || _positionSub != null) return;
    if (!await _ensurePermission()) return;

    try {
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
    } catch (_) {
      _positionSub = null;
    }
  }

  void _recenter() {
    if (_userPosition == null) {
      if (widget.enableLiveLocation) {
        _startTracking();
      } else {
        _showMessage('Acquiring GPS...');
      }
      return;
    }
    setState(() => _follow = true);
    _mapController.move(_userPosition!, 16);
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Styles.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.chip),
            side: const BorderSide(color: Styles.borderGlow),
          ),
          content: Text(
            text,
            style: const TextStyle(color: Styles.textPrimary),
          ),
        ),
      );
  }

  Future<void> _openSportFilter() async {
    final chosen = await showSportFilterSheet(
      context,
      selectedSport: _selectedSport,
    );
    if (chosen != null && mounted) {
      setState(() => _selectedSport = chosen);
    }
  }

  void _toggleMenuExpansion() {
    setState(() {
      _sheetFraction = _sheetFraction >= 0.52
          ? _collapsedFraction
          : _expandedFraction;
    });
  }

  String get _gpsStatusLabel =>
      _userPosition == null ? 'Acquiring GPS' : 'GPS Ready';

  @override
  Widget build(BuildContext context) {
    if (_isTelemetryFullScreen) {
      return _buildFullScreenTelemetry(context);
    }

    return Scaffold(
      backgroundColor: Styles.canvas,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalHeight = constraints.maxHeight;
          final totalBottomHeight = totalHeight * _sheetFraction;
          final menuHeight = (totalBottomHeight - _telemetryBarHeight).clamp(
            110.0,
            totalHeight * 0.62,
          );
          final showExtraItems = menuHeight > 165.0;

          return Stack(
            children: [
              Positioned.fill(
                child: widget.mapOverride?.call(context) ?? _buildMap(),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _buildCircleControl(
                      icon: Icons.chevron_left,
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleControl(
                            icon: Icons.info_outline,
                            tooltip: 'Map data sources',
                            onPressed: () => showMapDataSourcesSheet(context),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCircleControl(
                                icon: Icons.layers_outlined,
                                tooltip: 'Map layers',
                                onPressed: () => showMapLayersSheet(context),
                              ),
                              const SizedBox(height: 10),
                              _buildCircleControl(
                                icon: Icons.explore,
                                tooltip: 'Center map',
                                iconColor: _follow
                                    ? Styles.primaryLight
                                    : Styles.textPrimary,
                                onPressed: _recenter,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCompactTelemetryBar(),
                    _buildResizableMenu(
                      totalHeight: totalHeight,
                      menuHeight: menuHeight,
                      showExtraItems: showExtraItems,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(-6.2088, 106.8456),
        initialZoom: 14,
        onMapReady: widget.enableLiveLocation ? _startTracking : null,
        onPositionChanged: (camera, hasGesture) {
          if (hasGesture && _follow) {
            setState(() => _follow = false);
          }
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
                child: const UserLocationMarker(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCircleControl({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color iconColor = Styles.textPrimary,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.88),
        shape: BoxShape.circle,
        border: Border.all(color: Styles.border),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: iconColor, size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCompactTelemetryBar() {
    return Container(
      height: _telemetryBarHeight,
      decoration: const BoxDecoration(
        color: Styles.surfaceElevated,
        border: Border(
          top: BorderSide(color: Styles.border),
          bottom: BorderSide(color: Styles.border),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isTelemetryFullScreen = true),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _userPosition == null
                                ? Styles.warning
                                : Styles.success,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _gpsStatusLabel,
                          style: const TextStyle(
                            color: Styles.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.open_in_full_rounded,
                      color: Styles.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: _TelemetryMetricCell(
                        label: 'Time',
                        value: '00:00',
                      ),
                    ),
                    Expanded(
                      child: _TelemetryMetricCell(
                        label: 'Distance',
                        value: '0.00 km',
                      ),
                    ),
                    Expanded(
                      child: _TelemetryMetricCell(
                        label: 'Speed (km/h)',
                        value: '--.-',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResizableMenu({
    required double totalHeight,
    required double menuHeight,
    required bool showExtraItems,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: menuHeight,
      decoration: const BoxDecoration(
        color: Styles.surface,
        border: Border(top: BorderSide(color: Styles.borderStrong)),
      ),
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Column(
            children: [
              GestureDetector(
                key: const Key('record_track_drag_handle'),
                behavior: HitTestBehavior.opaque,
                onTap: _toggleMenuExpansion,
                onVerticalDragUpdate: (details) {
                  if (totalHeight <= 0) return;
                  setState(() {
                    _sheetFraction =
                        (_sheetFraction - details.delta.dy / totalHeight).clamp(
                          _collapsedFraction,
                          _expandedFraction,
                        );
                  });
                },
                onVerticalDragEnd: (_) {
                  setState(() {
                    _sheetFraction = _sheetFraction >= 0.52
                        ? _expandedFraction
                        : _collapsedFraction;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Styles.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: _buildThreeColumnActionBar(),
              ),
              if (showExtraItems)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: const [
                      Divider(color: Styles.divider),
                      _MenuOptionTile(
                        icon: Icons.share_location_outlined,
                        title: 'Share live location',
                        subtitle: 'Off',
                      ),
                      _MenuOptionTile(
                        icon: Icons.navigation_outlined,
                        title: 'Navigation',
                        subtitle: 'Off',
                      ),
                      _MenuOptionTile(
                        icon: Icons.sensors_outlined,
                        title: 'Add a sensor',
                      ),
                      _MenuOptionTile(
                        icon: Icons.tune_outlined,
                        title: 'Settings',
                        subtitle: 'Audio cues, auto-pause, live segments',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThreeColumnActionBar() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.chip),
            onTap: _openSportFilter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _selectedSport.icon,
                    color: Styles.primaryLight,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedSport.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Styles.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Semantics(
              button: true,
              label: _isRecording ? 'Pause recording' : 'Start recording',
              child: Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.primary,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _isRecording = !_isRecording),
                    child: Icon(
                      _isRecording
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Styles.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.chip),
            onTap: () => _showMessage('Add Route coming soon.'),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.alt_route_rounded,
                    color: Styles.textSecondary,
                    size: 24,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add Route',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Styles.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenTelemetry(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleControl(
                    icon: Icons.chevron_left,
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.surfaceElevated,
                      borderRadius: BorderRadius.circular(Radii.chip),
                      border: Border.all(color: Styles.border),
                    ),
                    child: Text(
                      _gpsStatusLabel,
                      style: const TextStyle(
                        color: Styles.textSecondary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildCircleControl(
                    icon: Icons.close_fullscreen_rounded,
                    tooltip: 'Exit full screen',
                    onPressed: () =>
                        setState(() => _isTelemetryFullScreen = false),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TIME',
                      style: TextStyle(
                        color: Styles.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '00:00',
                      style: TextStyle(
                        color: Styles.textPrimary,
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Styles.divider, height: 1),
            const Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'DISTANCE (KM)',
                            style: TextStyle(
                              color: Styles.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '0.00',
                            style: TextStyle(
                              color: Styles.textPrimary,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(color: Styles.divider, width: 1),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SPEED (KM/H)',
                            style: TextStyle(
                              color: Styles.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '--.-',
                            style: TextStyle(
                              color: Styles.textPrimary,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Styles.surface,
                border: Border(top: BorderSide(color: Styles.borderStrong)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildThreeColumnActionBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryMetricCell extends StatelessWidget {
  final String label;
  final String value;

  const _TelemetryMetricCell({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Styles.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Styles.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _MenuOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _MenuOptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: Styles.primaryLight, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Styles.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(
                color: Styles.textSecondary,
                fontSize: 12,
              ),
            ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Styles.textMuted,
      ),
    );
  }
}
