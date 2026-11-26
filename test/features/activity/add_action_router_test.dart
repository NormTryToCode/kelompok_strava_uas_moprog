import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/create_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';

class _StubClubsNotifier extends ClubsNotifier {
  final List<Club> clubs;

  _StubClubsNotifier(this.clubs);

  @override
  Future<List<Club>> build() async => clubs;
}

Club _club(String id, String name) {
  return Club(
    id: id,
    name: name,
    description: 'Community club',
    sport: ClubSport.option.firstWhere((s) => s.id == 'running'),
    types: const [],
    privacy: ClubPrivacy.public,
    isGlobal: true,
    location: null,
    memberCount: 15,
    createdAt: DateTime(2026, 11, 23),
  );
}

Widget _wrap(AddAction action, {List<Club> clubs = const []}) {
  return ProviderScope(
    overrides: [
      clubsProvider.overrideWith(() => _StubClubsNotifier(clubs)),
      activityStoreProvider.overrideWithValue(MemoryActivityStore()),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => openAddAction(context, action),
            child: const Text('trigger'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('manualActivity membuka ManualActivityPage', (tester) async {
    await tester.pumpWidget(_wrap(AddAction.manualActivity));

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.byType(ManualActivityPage), findsOneWidget);
  });

  testWidgets('activityHistory membuka ActivityListPage', (tester) async {
    await tester.pumpWidget(_wrap(AddAction.activityHistory));

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityListPage), findsOneWidget);
  });

  testWidgets('post menampilkan snackbar saat belum ada klub', (tester) async {
    await tester.pumpWidget(_wrap(AddAction.post));

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(
      find.text('Create a club in Groups first to publish a post.'),
      findsOneWidget,
    );
  });

  testWidgets('post langsung membuka CreatePostPage bila hanya ada satu klub',
      (tester) async {
    await tester.pumpWidget(
      _wrap(AddAction.post, clubs: [_club('c1', 'Stride Runners')]),
    );

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.byType(CreatePostPage), findsOneWidget);
  });

  testWidgets('post menampilkan ClubPickerSheet bila ada lebih dari satu klub',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AddAction.post,
        clubs: [_club('c1', 'Stride Runners'), _club('c2', 'Stride Cyclists')],
      ),
    );

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a club'), findsOneWidget);
    await tester.tap(find.text('Stride Cyclists'));
    await tester.pumpAndSettle();

    expect(find.byType(CreatePostPage), findsOneWidget);
  });
}