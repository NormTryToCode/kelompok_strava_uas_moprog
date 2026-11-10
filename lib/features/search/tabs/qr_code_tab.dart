import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/qr_placeholder_painter.dart';

class QrCodeTab extends StatelessWidget {
  final String username;

  const QrCodeTab({super.key, this.username = 'you'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(
                key: const Key('qr-code'),
                size: const Size(200, 200),
                painter: QrPlaceholderPainter(seed: username),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your QR code',
              style: TextStyle(
                color: Styles.tabActive,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Friends can scan this code to follow you',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scanner is not available in this demo'),
                ),
              ),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan a code'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Styles.accent,
                side: const BorderSide(color: Styles.accent),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}