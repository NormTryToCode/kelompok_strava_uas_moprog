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

class _SegmentLocationViewState extends State<SegmentLocationView> {
  final ProfileLocationService _locationService = ProfileLocationService();
  final ProfileUrlService _urlService = ProfileUrlService();

  double lat = 0.0;
  double lng = 0.0;
  bool isLoading = false;
  String errorMessage = '';

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
        'Koordinat GPS segmen berhasil diperbarui!',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      ProfileSnackbarHelper.showError(context, 'Gagal memuat lokasi GPS.');
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 88.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Styles.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Segmen & Koordinat GPS',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: Styles.cardDecoration(
                  radius: Radii.card,
                  highlighted: true,
                  withGlow: true,
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasLocation
                        ? Icons.my_location_rounded
                        : Icons.location_searching_rounded,
                      color: hasLocation ? Styles.success : Styles.primaryLight,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Titik Koordinat Atlet Saat Ini',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lat: ${hasLocation ? lat.toStringAsFixed(4) : '0.0000'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lng: ${hasLocation ? lng.toStringAsFixed(4) : '0.0000'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Styles.primaryLight,
                      ),
                    ),
                    if (hasLocation) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Styles.surfaceElevated,
                          foregroundColor: Styles.textPrimary,
                          side: const BorderSide(color: Styles.primaryLight),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.button),
                          ),
                        ),
                        onPressed: _openLocationInBrowser,
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          size: 17,
                          color: Styles.primaryLight,
                        ),
                        label: const Text(
                          'Buka Koordinat di Peta Web',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: CircularProgressIndicator(
                          color: Styles.primaryLight,
                        ),
                      ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Styles.danger,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Segmen Lari Terdekat dari Titik GPS',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (!hasLocation)
                const Text(
                  'Tekan tombol navigasi di kanan bawah untuk memindai koordinat GPS Anda dan menemukan segmen lari terdekat.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Styles.textSecondary,
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      decoration: Styles.cardDecoration(radius: Radii.field),
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GBK Outer Ring Sprint 1.2K',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Koordinat Terkunci (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Styles.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '1,2 km',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: Styles.cardDecoration(radius: Radii.field),
                      padding: const EdgeInsets.all(15.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sudirman Loop Fast Segment',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Elevasi 0.4% • Rute Terverifikasi GPS',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Styles.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '3,5 km',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Styles.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.primary,
        foregroundColor: Styles.textPrimary,
        onPressed: _fetchGpsCoordinates,
        child: const Icon(Icons.navigation_rounded),
      ),
    );
  }
}