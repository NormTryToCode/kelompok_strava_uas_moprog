import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/club_share_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_invite/widgets/club_qr_painter.dart';

class ClubQrCodePage extends StatelessWidget {
  final Club club;

  const ClubQrCodePage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => ClubQrCodePage(club: club)));
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: ClubShareService.clubUrl(club)),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Club link copied')));
  }

  @override
  Widget build(BuildContext context) {
    final clubUrl = ClubShareService.clubUrl(club);

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'QR Code',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Scan to join',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  club.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(224, 224),
                      painter: ClubQrPainter(
                        seed: clubUrl,
                        foregroundColor: Styles.accent,
                        backgroundColor: Styles.canvas,
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Styles.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        club.sport.icon,
                        size: 28,
                        color: Styles.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                OutlinedButton(
                  onPressed: () => _copyLink(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Styles.accent,
                    side: BorderSide(color: Styles.accent.withAlpha(130)),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Copy Link',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

