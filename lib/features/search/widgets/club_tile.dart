import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

class ClubTile extends StatelessWidget {
  final SearchClub club;
  final VoidCallback? onTap;

  const ClubTile({super.key, required this.club, this.onTap});

  static const List<Color> _palette = [
    Color(0xFF1E5AA8),
    Color(0xFF7B3FB5),
    Color(0xFF0F7B6C),
    Color(0xFFB23A48),
    Color(0xFF3D4F7C),
    Color(0xFF9A6B00),
  ];

  Color get _logoColor {
    final sum = club.id.codeUnits.fold<int>(0, (a, b) => a + b);
    return _palette[sum % _palette.length];
  }

  Widget _initialsBox() {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _logoColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        club.initials,
        style: const TextStyle(
          color: Styles.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final path = club.avatarPath?.trim();
    if (path == null || path.isEmpty) return _initialsBox();
    final isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: isNetwork
          ? Image.network(
              path,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _initialsBox(),
            )
          : Image.file(
              File(path),
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _initialsBox(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildAvatar(),
                if (club.isVerified)
                  const Positioned(
                    right: -6,
                    top: -6,
                    child: Icon(Icons.verified, size: 20, color: Styles.accent),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Styles.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Styles.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}