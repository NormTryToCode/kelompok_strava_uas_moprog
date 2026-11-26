import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_detail/widgets/club_info_row.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';

class ClubDetailHeader extends StatelessWidget {
  final Club club;
  final VoidCallback onBack;
  final VoidCallback? onSettings;

  const ClubDetailHeader({
    super.key,
    required this.club,
    required this.onBack,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final coverPath = club.coverPath;
    final hasCover = coverPath != null && coverPath.isNotEmpty;

    return Stack(
      children: [
        if (hasCover)
          Positioned.fill(
            child: Image.file(
              File(coverPath),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, top + 8, 20, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: hasCover
                  ? [
                      Styles.canvas.withAlpha(120),
                      Styles.canvas.withAlpha(205),
                      Styles.canvas,
                    ]
                  : const [Styles.surface, Styles.canvas],
              stops: hasCover ? const [0, 0.65, 1] : const [0, 1],
            ),
            border: const Border(
              bottom: BorderSide(color: Styles.cardBorder, width: 0.8),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _RoundButton(icon: Icons.arrow_back, onTap: onBack),
                  const Spacer(),
                  if (onSettings != null)
                    _RoundButton(
                      icon: Icons.settings_outlined,
                      onTap: onSettings!,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClubAvatar(
                club: club,
                size: 96,
                ringColor: Colors.white.withAlpha(70),
              ),
              const SizedBox(height: 14),
              Text(
                club.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ClubInfoRow(club: club),
              if (club.types.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  club.typeLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
              if (club.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  club.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.4,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(110),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

