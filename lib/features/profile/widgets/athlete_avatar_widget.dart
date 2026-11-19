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

  static const String _defaultAvatarUrl =
      'https://cdn-icons-png.flaticon.com/512/4140/4140048.png';

  @override
  Widget build(BuildContext context) {
    final bool hasLocalFile =
        avatarPath.isNotEmpty && File(avatarPath).existsSync();

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasLocalFile
          ? Image.file(
            File(avatarPath),
            width: size,
            height: size,
            fit: BoxFit.cover,
          )
          : CustomImageNetwork(
            imageUrl: _defaultAvatarUrl,
            height: size,
          ),
      ),
    );
  }
}