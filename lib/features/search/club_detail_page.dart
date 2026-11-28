import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/joined_clubs_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SearchClubDetailPage extends ConsumerWidget {
  final SearchClub club;

  const SearchClubDetailPage({super.key, required this.club});

  Widget _buildHeaderAvatar() {
    final path = club.avatarPath?.trim();
    if (path == null || path.isEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundColor: Styles.surfaceHighlight,
        child: Text(
          club.initials,
          style: const TextStyle(
            color: Styles.primaryLight,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    final isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: isNetwork
          ? Image.network(path, width: 64, height: 64, fit: BoxFit.cover)
          : Image.file(File(path), width: 64, height: 64, fit: BoxFit.cover),
    );
  }

  Future<void> _toggleJoin(WidgetRef ref) async {
    final justJoined = ref.read(joinedClubsProvider.notifier).toggle(club.id);
    if (justJoined) {
      ref
          .read(notificationsProvider.notifier)
          .notifyClubJoined(clubName: club.name);
    }
    try {
      final groupsClubs = ref.read(clubsProvider).valueOrNull;
      if (groupsClubs != null && groupsClubs.any((c) => c.id == club.id)) {
        if (justJoined) {
          await ref.read(clubsProvider.notifier).joinClub(club.id);
        } else {
          await ref.read(clubsProvider.notifier).leaveClub(club.id);
        }
      }
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinedIds = ref.watch(joinedClubsProvider);
    final isJoined = joinedIds.contains(club.id);
    final displayedClub = isJoined
        ? club.copyWith(memberCount: club.memberCount + 1)
        : club;

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: const AppHeader(title: 'Club', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderAvatar(),
            const SizedBox(height: 16),
            Text(
              displayedClub.name,
              style: const TextStyle(
                color: Styles.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displayedClub.subtitle,
              style: const TextStyle(color: Styles.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              displayedClub.sport.label,
              style: const TextStyle(
                color: Styles.primaryLight,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => _toggleJoin(ref),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isJoined ? Styles.surfaceElevated : Styles.primary,
                  foregroundColor: Styles.textPrimary,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  isJoined ? 'Joined' : 'Join Club',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}