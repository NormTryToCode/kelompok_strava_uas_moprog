import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:share_plus/share_plus.dart';

class ProfileShareHelper {
  ProfileShareHelper._();

  static String buildProfileUrl(String athleteName) {
    final String slug = athleteName
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '_');
    return '${AppBrand.inviteLink}/$slug';
  }

  static Future<String> shareAthleteProfile(String athleteName) async {
    final String profileUrl = buildProfileUrl(athleteName);
    final String shareText =
      'Check out $athleteName\'s ${AppBrand.name} Athlete Pass: $profileUrl';

    await Clipboard.setData(ClipboardData(text: profileUrl));

    final ShareResult result = await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: '${AppBrand.name} Athlete Pass — $athleteName',
      ),
    );

    if (result.status == ShareResultStatus.success) {
      return 'Athlete Pass shared successfully!';
    }
    return 'Profile link copied to clipboard';
  }
}