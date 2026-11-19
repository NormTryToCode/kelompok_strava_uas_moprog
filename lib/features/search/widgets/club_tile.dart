import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';

class ClubTile extends StatelessWidget {
  final Club club;
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
                Container(
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
                      color: Styles.tabActive,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
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
                      color: Styles.tabActive,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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