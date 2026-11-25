import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';

class ClubAvatar extends StatelessWidget {
  final Club club;
  final double size;
  final Color? ringColor;

  const ClubAvatar({
    super.key,
    required this.club,
    this.size = 56,
    this.ringColor,
  });

  String get _initials {
    final words = club.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = club.avatarPath;
    final hasImage = path != null && path.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: Styles.coverFor(club.id),
        border: Border.all(
          color: ringColor ?? Styles.surface,
          width: size * 0.07,
        ),
      ),
      child: ClipOval(
        child: hasImage
            ? Image.file(
                File(path),
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, _, _) => _buildInitials(),
              )
            : _buildInitials(),
      ),
    );
  }
}

