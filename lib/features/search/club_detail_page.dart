import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/joined_clubs_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SearchClubDetailPage extends ConsumerWidget {
  final SearchClub club;

  const SearchClubDetailPage({super.key, required this.club});

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
                onPressed: () {
                  final justJoined =
                      ref.read(joinedClubsProvider.notifier).toggle(club.id);
                  if (justJoined) {
                    ref
                        .read(notificationsProvider.notifier)
                        .notifyClubJoined(clubName: club.name);
                  }
                },
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