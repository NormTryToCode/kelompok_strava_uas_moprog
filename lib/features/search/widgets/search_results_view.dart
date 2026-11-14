import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_all.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/club_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/follow_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/person_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

class SearchResultsView extends StatelessWidget {
  final SearchResults results;
  final FollowController follow;
  final ValueChanged<Club> onClubTap;

  const SearchResultsView({
    super.key,
    required this.results,
    required this.follow,
    required this.onClubTap,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Styles.tabActive, fontSize: 18),
        ),
      );
    }

    return ListenableBuilder(
      listenable: follow,
      builder: (context, _) => ListView(
        children: [
          if (results.people.isNotEmpty) ...[
            const _ResultsLabel('PEOPLE'),
            for (final person in results.people)
              PersonTile(
                person: person,
                trailing: FollowButton(
                  isFollowing: follow.isFollowing(person.id),
                  onPressed: () => follow.toggle(person.id),
                ),
              ),
          ],
          if (results.clubs.isNotEmpty) ...[
            const _ResultsLabel('CLUBS'),
            for (final club in results.clubs)
              ClubTile(club: club, onTap: () => onClubTap(club)),
          ],
        ],
      ),
    );
  }
}

class _ResultsLabel extends StatelessWidget {
  final String text;

  const _ResultsLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Styles.surface,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Styles.tabActive,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}