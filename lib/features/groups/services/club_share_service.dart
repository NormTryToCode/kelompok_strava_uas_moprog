import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:path_provider/path_provider.dart';

class ShareTarget {
  final String label;
  final String packageName;
  final String activityName;
  final bool supportsImage;
  final Uint8List iconBytes;

  const ShareTarget({
    required this.label,
    required this.packageName,
    required this.activityName,
    required this.supportsImage,
    required this.iconBytes,
  });
}

class ClubShareService {
  static const _channel = MethodChannel(
    'kelompok_strava_uas_moprog/club_share',
  );

  static String clubUrl(Club club) {
    final vanity = club.vanityUrl?.trim();
    final slug = (vanity != null && vanity.isNotEmpty) ? vanity : club.id;
    return 'https://strava.com/clubs/$slug';
  }

  static String shareMessage(Club club) {
    return 'Join ${club.name} (${club.sport.name})! '
        'Make some friends, get some kudos, and train together: ${clubUrl(club)}';
  }

  Future<List<ShareTarget>> getInstalledTargets() async {
    if (!Platform.isAndroid) return const [];

    try {
      final raw = await _channel.invokeListMethod<dynamic>('getShareTargets');
      if (raw == null) return const [];

      return [
        for (final item in raw)
          if (item is Map)
            ShareTarget(
              label: item['label'] as String? ?? '',
              packageName: item['packageName'] as String? ?? '',
              activityName: item['activityName'] as String? ?? '',
              supportsImage: item['supportsImage'] as bool? ?? false,
              iconBytes: item['icon'] as Uint8List? ?? Uint8List(0),
            ),
      ];
    } on PlatformException {
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  Future<String> writePosterToCache(Uint8List bytes, String clubId) async {
    final tempDir = await getTemporaryDirectory();
    final folder = Directory(
      '${tempDir.path}${Platform.pathSeparator}club_shares',
    );
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final file = File(
      '${folder.path}${Platform.pathSeparator}club_${clubId}_poster.png',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<String> downloadPoster(Uint8List bytes, Club club) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeName = club.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final fileName =
        '${safeName.isEmpty ? 'club' : safeName}_poster_${DateTime.now().millisecondsSinceEpoch}.png';

    final file = File('${dir.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<bool> share({
    required String text,
    String? imagePath,
    ShareTarget? target,
  }) async {
    if (!Platform.isAndroid) return false;

    try {
      final useImage = target == null || target.supportsImage;
      final ok = await _channel.invokeMethod<bool>('share', {
        'text': text,
        'imagePath': useImage ? imagePath : null,
        'packageName': target?.packageName,
        'activityName': target?.activityName,
      });
      return ok ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}