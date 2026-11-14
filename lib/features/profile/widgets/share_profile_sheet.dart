import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ProfileShareHelper {
  ProfileShareHelper._();

  static Future<String> shareAthleteProfile(String athleteName) async {
    final String slug = athleteName.toLowerCase().replaceAll(' ', '_');
    final String profileUrl = 'https://strava.app.link/athlete/$slug';
    final String shareText =
        'Lihat profil atlet Strava $athleteName di sini: $profileUrl';

    await Clipboard.setData(ClipboardData(text: profileUrl));

    final ShareResult result = await Share.share(
      shareText,
      subject: 'Profil Strava $athleteName',
    );

    if (result.status == ShareResultStatus.success) {
      return 'Profil $athleteName berhasil dibagikan!';
    }
    return 'Tautan profil disalin ke papan klip';
  }
}