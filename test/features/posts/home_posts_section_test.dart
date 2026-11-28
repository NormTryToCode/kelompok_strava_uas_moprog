import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/post_store.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/widgets/home_posts_section.dart';

void main() {
  testWidgets('menampilkan empty state saat belum ada postingan', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        postStoreProvider.overrideWithValue(MemoryPostStore()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(feedPostsProvider.notifier).load();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: HomePostsSection()),
          ),
        ),
      ),
    );

    expect(find.text('No posts yet'), findsOneWidget);
    expect(find.text('Create Post'), findsOneWidget);
  });

  testWidgets('menampilkan postingan, mendukung like dan hapus milik sendiri', (
    tester,
  ) async {
    final ownPost = FeedPost(
      id: 'p1',
      authorId: defaultStorageUserId,
      authorName: 'Angga',
      title: 'Morning 5K',
      caption: 'Felt strong around GBK',
      createdAt: DateTime(2026, 11, 28, 7, 0),
    );
    final otherPost = FeedPost(
      id: 'p2',
      authorId: 'other_user_uid',
      authorName: 'Cake',
      title: 'Evening Ride',
      caption: 'Chill ride downtown',
      createdAt: DateTime(2026, 11, 28, 6, 0),
    );

    final container = ProviderContainer(
      overrides: [
        postStoreProvider.overrideWithValue(
          MemoryPostStore([ownPost, otherPost]),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(feedPostsProvider.notifier).load();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: HomePostsSection()),
          ),
        ),
      ),
    );

    expect(find.text('Morning 5K'), findsOneWidget);
    expect(find.text('Evening Ride'), findsOneWidget);
    expect(find.byTooltip('Delete Morning 5K'), findsOneWidget);
    expect(find.byTooltip('Delete Evening Ride'), findsNothing);

    await tester.tap(find.text('0 likes').first);
    await tester.pumpAndSettle();
    expect(find.text('1 likes'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete Morning 5K'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Post?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Morning 5K'), findsNothing);
    expect(find.text('Evening Ride'), findsOneWidget);
  });
}