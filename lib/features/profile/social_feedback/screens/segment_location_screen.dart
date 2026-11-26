import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../shared/services/profile_location_service.dart';
import '../../shared/services/profile_url_service.dart';
import '../../shared/utils/profile_snackbar_helper.dart';

class SegmentLocationView extends StatefulWidget {
  final VoidCallback onBack;

  const SegmentLocationView({
    super.key,
    required this.onBack,
  });

  @override
  State<SegmentLocationView> createState() => _SegmentLocationViewState();
}

class _SegmentLocationViewState extends State<SegmentLocationView>
  with SingleTickerProviderStateMixin {
    final ProfileLocationService _locationService = ProfileLocationService();
    final ProfileUrlService _urlService = ProfileUrlService();

    late final AnimationController _radarController;

    double lat = 0.0;
    double lng = 0.0;
    bool isLoading = false;
    String errorMessage = '';

    @override
    void initState() {
      super.initState();
      _radarController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat();
    }

    @override
    void dispose() {
      _radarController.dispose();
      super.dispose();
    }

    Future<void> _fetchGpsCoordinates() async {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      try {
        await _locationService.getCurrentLocation();
        if (!mounted) return;
        setState(() {
          lat = _locationService.lat;
          lng = _locationService.lng;
          isLoading = false;
        });
        ProfileSnackbarHelper.showSuccess(
          context,
          'GPS satellite lock acquired!',
        );
      } catch (e) {
        if (!mounted) return;
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
        ProfileSnackbarHelper.showError(context, 'Failed to read GPS location.');
      }
    }

    Future<void> _openLocationInBrowser() async {
      final String mapUrl =
        'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng';
      try {
        await _urlService.openUrl(mapUrl);
      } catch (e) {
        if (!mounted) return;
        ProfileSnackbarHelper.showError(context, '$e');
      }
    }

    @override
    Widget build(BuildContext context) {
      final bool hasLocation = (lat != 0.0 || lng != 0.0);

      return Scaffold(
        backgroundColor: Styles.canvas,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Styles.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Styles.borderStrong),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Styles.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GPS Route Radar',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          Text(
                            'Live Satellite Fix & Nearby Segments',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Styles.border),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 92),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: Styles.cardDecoration(
                          radius: Radii.card,
                          highlighted: true,
                          withGlow: true,
                        ),
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SATELLITE TELEMETRY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                    color: Styles.primaryLight,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (hasLocation
                                      ? Styles.success
                                      : Styles.primary)
                                    .withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: hasLocation
                                        ? Styles.success
                                        : Styles.primaryLight,
                                    ),
                                  ),
                                  child: Text(
                                    isLoading
                                      ? 'SCANNING...'
                                      : hasLocation
                                        ? 'SIGNAL LOCKED'
                                        : 'STANDBY',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: hasLocation
                                        ? Styles.success
                                        : Styles.primaryLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 176,
                              height: 176,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 176,
                                    height: 176,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: Styles.radialGlow(
                                        color: hasLocation
                                          ? Styles.success
                                          : Styles.primary,
                                        intensity: 0.25,
                                      ),
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _radarController,
                                    builder: (context, _) {
                                      return CustomPaint(
                                        size: const Size(168, 168),
                                        painter: _RadarRingsPainter(
                                          sweepAngle:
                                            _radarController.value * 2 * math.pi,
                                          isLocked: hasLocation,
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Styles.canvas,
                                      border: Border.all(
                                        color: hasLocation
                                          ? Styles.success
                                          : Styles.primaryLight,
                                        width: 2,
                                      ),
                                      boxShadow: Styles.glow(
                                        color: hasLocation
                                          ? Styles.success
                                          : Styles.primary,
                                        intensity: 0.45,
                                        blur: 14,
                                      ),
                                    ),
                                    child: isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(9),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Styles.primaryLight,
                                          ),
                                        )
                                      : Icon(
                                          hasLocation
                                            ? Icons.my_location_rounded
                                            : Icons.radar_rounded,
                                          size: 19,
                                          color: hasLocation
                                            ? Styles.success
                                            : Styles.primaryLight,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: _CoordinateBox(
                                    label: 'LATITUDE',
                                    value: hasLocation
                                      ? lat.toStringAsFixed(4)
                                      : '0.0000',
                                    active: hasLocation,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _CoordinateBox(
                                    label: 'LONGITUDE',
                                    value: hasLocation
                                      ? lng.toStringAsFixed(4)
                                      : '0.0000',
                                    active: hasLocation,
                                  ),
                                ),
                              ],
                            ),
                            if (hasLocation) ...[
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                      Styles.canvas.withValues(alpha: 0.6),
                                    foregroundColor: Styles.textPrimary,
                                    side: const BorderSide(
                                      color: Styles.primaryLight,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 11,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                        BorderRadius.circular(Radii.button),
                                    ),
                                  ),
                                  onPressed: _openLocationInBrowser,
                                  icon: const Icon(
                                    Icons.open_in_new_rounded,
                                    size: 17,
                                    color: Styles.primaryLight,
                                  ),
                                  label: const Text(
                                    'Open Coordinates in Web Map',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                            if (errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  errorMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Styles.danger,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: Styles.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'NEARBY VERIFIED SEGMENTS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!hasLocation)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: Styles.cardDecoration(radius: Radii.card),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.satellite_alt_rounded,
                                size: 36,
                                color: Styles.primaryLight,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Ready to Scan Your Area',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Styles.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Tap the scan button below to lock your GPS coordinates and reveal nearby Stride segments.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.4,
                                  color: Styles.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primary,
                                  foregroundColor: Styles.textPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 11,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                      BorderRadius.circular(Radii.button),
                                  ),
                                ),
                                onPressed: _fetchGpsCoordinates,
                                icon: const Icon(
                                  Icons.my_location_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Scan GPS Now',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            _SegmentRouteCard(
                              title: 'GBK Outer Ring Sprint',
                              subtitle:
                                'GPS Locked (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})',
                              distance: '1.2 km',
                              gradeTag: '0.2% Flat • Fast',
                              isVerified: true,
                            ),
                            const SizedBox(height: 10),
                            const _SegmentRouteCard(
                              title: 'Sudirman Tempo Corridor',
                              subtitle: 'Verified urban straightaway loop',
                              distance: '3.5 km',
                              gradeTag: '0.4% Grade • Tempo',
                              isVerified: false,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Styles.primary,
          foregroundColor: Styles.textPrimary,
          onPressed: _fetchGpsCoordinates,
          icon: const Icon(Icons.navigation_rounded),
          label: Text(
            hasLocation ? 'Rescan GPS' : 'Scan GPS',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
    }
}

class _CoordinateBox extends StatelessWidget {
  final String label;
  final String value;
  final bool active;

  const _CoordinateBox({
    required this.label,
    required this.value,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Styles.canvas.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(Radii.field),
        border: Border.all(
          color: active
            ? Styles.success.withValues(alpha: 0.5)
            : Styles.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: Styles.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              color: active ? Styles.success : Styles.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentRouteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String distance;
  final String gradeTag;
  final bool isVerified;

  const _SegmentRouteCard({
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.gradeTag,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Styles.cardDecoration(radius: Radii.card),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Styles.surfaceHighlight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Styles.primary.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              isVerified ? Icons.flag_rounded : Icons.route_rounded,
              color: isVerified ? Styles.success : Styles.primaryLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isVerified ? Styles.success : Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.canvas.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Styles.border),
                  ),
                  child: Text(
                    gradeTag,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Styles.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Styles.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarRingsPainter extends CustomPainter {
  final double sweepAngle;
  final bool isLocked;

  const _RadarRingsPainter({
    required this.sweepAngle,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = (math.min(size.width, size.height) / 2) - 4;
    final Color activeColor = isLocked ? Styles.success : Styles.primaryLight;

    final Paint ringPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, maxRadius, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.68, ringPaint);
    canvas.drawCircle(center, maxRadius * 0.36, ringPaint);

    final Paint axisPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      axisPaint,
    );

    final Rect radarRect = Rect.fromCircle(center: center, radius: maxRadius);
    final Paint sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          Colors.transparent,
          activeColor.withValues(alpha: 0.32),
        ],
        transform: GradientRotation(sweepAngle),
      ).createShader(radarRect)
      ..style = PaintingStyle.fill;

    canvas.drawArc(radarRect, sweepAngle, math.pi / 2, true, sweepPaint);

    final double beamAngle = sweepAngle + math.pi / 2;
    canvas.drawLine(
      center,
      Offset(
        center.dx + maxRadius * math.cos(beamAngle),
        center.dy + maxRadius * math.sin(beamAngle),
      ),
      Paint()
        ..color = activeColor.withValues(alpha: 0.75)
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    if (isLocked) {
      final List<Offset> blips = [
        Offset(center.dx + maxRadius * 0.48, center.dy - maxRadius * 0.38),
        Offset(center.dx - maxRadius * 0.56, center.dy + maxRadius * 0.28),
      ];
      for (final blip in blips) {
        canvas.drawCircle(
          blip,
          6,
          Paint()..color = Styles.success.withValues(alpha: 0.25),
        );
        canvas.drawCircle(
          blip,
          3,
          Paint()..color = Styles.success,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.isLocked != isLocked;
  }
}