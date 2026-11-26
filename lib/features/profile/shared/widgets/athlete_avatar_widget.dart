import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'custom_image_network.dart';

class AthleteAvatarWidget extends StatelessWidget {
  final String avatarPath;
  final double size;

  const AthleteAvatarWidget({
    super.key,
    required this.avatarPath,
    this.size = 68.0,
  });

  static const String defaultAvatarUrl =
      'https://cdn-icons-png.flaticon.com/512/4140/4140048.png';

  static Widget buildImage(
    String avatarPath, {
    double? size,
    BoxFit fit = BoxFit.cover,
  }) {
    final trimmed = avatarPath.trim();

    if (trimmed.startsWith('data:image/')) {
      final commaIndex = trimmed.indexOf(',');
      if (commaIndex != -1) {
        try {
          final bytes = base64Decode(trimmed.substring(commaIndex + 1));
          return Image.memory(
            bytes,
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (_, _, _) => CustomImageNetwork(
              imageUrl: defaultAvatarUrl,
              width: size,
              height: size,
              fit: fit,
            ),
          );
        } catch (_) {}
      }
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return CustomImageNetwork(
        imageUrl: trimmed,
        width: size,
        height: size,
        fit: fit,
      );
    }

    if (trimmed.isNotEmpty && File(trimmed).existsSync()) {
      return Image.file(
        File(trimmed),
        width: size,
        height: size,
        fit: fit,
      );
    }

    return CustomImageNetwork(
      imageUrl: defaultAvatarUrl,
      width: size,
      height: size,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: buildImage(avatarPath, size: size),
      ),
    );
  }
}