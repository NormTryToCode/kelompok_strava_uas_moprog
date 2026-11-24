import 'package:url_launcher/url_launcher.dart';

class ProfileUrlService {
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka tautan: $url');
    }
  }
}