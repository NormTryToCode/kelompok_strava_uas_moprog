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
      backgroundColor: Styles.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Styles.tabActive,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Segmen & Koordinat GPS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Styles.tabActive,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Styles.surface,
                  borderRadius: BorderRadius.circular(Radii.field),
                  border: Border.all(color: Palette.cardBorder),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasLocation
                        ? Icons.my_location
                        : Icons.location_searching,
                      color: hasLocation ? Styles.active : Styles.accent,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Titik Koordinat Atlet Saat Ini',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lat: $lat',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Styles.accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lng: $lng',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Styles.accent,
                      ),
                    ),
                    if (hasLocation) ...[
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Styles.tabActive,
                          side: const BorderSide(color: Styles.accent),
                        ),
                        onPressed: _openLocationInBrowser,
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Styles.accent,
                        ),
                        label: const Text('Buka Koordinat di Peta Web'),
                      ),
                    ],
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: CircularProgressIndicator(color: Styles.accent),
                      ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Styles.accent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Segmen Lari Terdekat dari Titik GPS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Styles.tabActive,
                ),
              ),
              const SizedBox(height: 10),
              if (!hasLocation)
                const Text(
                  'Tekan tombol navigasi di kanan bawah untuk memindai koordinat GPS Anda dan menemukan segmen lari terdekat.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Styles.tabInactive,
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      color: Styles.surface,
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GBK Outer Ring Sprint 1.2K',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.tabActive,
                                ),
                              ),
                              Text(
                                'Koordinat Terkunci (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Styles.active,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            '1,2 km',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Styles.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: Styles.surface,
                      padding: const EdgeInsets.all(14.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sudirman Loop Fast Segment',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.tabActive,
                                ),
                              ),
                              Text(
                                'Elevasi 0.4% • Rute Terverifikasi GPS',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.tabInactive,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '3,5 km',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Styles.accent,
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
        backgroundColor: Styles.accent,
        onPressed: _fetchGpsCoordinates,
        child: const Icon(
          Icons.navigation,
          color: Styles.tabActive,
        ),
      ),
    );
  }
}