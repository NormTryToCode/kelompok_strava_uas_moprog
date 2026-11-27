import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_store.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/create_feed_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/post_store.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_store.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';

Widget _wrap(AddAction action) {
  return ProviderScope(
    overrides: [
      activityStoreProvider.overrideWithValue(MemoryActivityStore()),
      settingsStoreProvider.overrideWithValue(MemorySettingsStore()),
      postStoreProvider.overrideWithValue(MemoryPostStore()),
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

  testWidgets('post membuka CreateFeedPostPage mandiri', (tester) async {
    await tester.pumpWidget(_wrap(AddAction.post));
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateFeedPostPage), findsOneWidget);
  });
}