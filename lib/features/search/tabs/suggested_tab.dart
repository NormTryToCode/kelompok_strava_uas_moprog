import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/follow_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/person_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';

class SuggestedTab extends ConsumerWidget {
  final List<Person>? people;

  const SuggestedTab({super.key, this.people});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(followProvider);
    final list = people ?? buildDummyPeople();

    return Column(
      children: [
        const _SectionLabel('PEOPLE YOU MAY KNOW'),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final person = list[i];
              return PersonTile(
                person: person,
                trailing: FollowButton(
                  isFollowing: following.contains(person.id),
                  onPressed: () =>
                      ref.read(followProvider.notifier).toggle(person.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

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