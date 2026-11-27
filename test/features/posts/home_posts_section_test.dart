import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/post_store.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/widgets/home_posts_section.dart';

void main() {
  testWidgets('menampilkan keadaan kosong saat belum ada postingan',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [postStoreProvider.overrideWithValue(MemoryPostStore())],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: HomePostsSection())),
        ),
      ),
    );

    expect(find.text('Community Feed'), findsOneWidget);
    expect(find.text('No posts yet'), findsOneWidget);
  });

  testWidgets('menampilkan postingan, mendukung like dan hapus',
      (tester) async {
    final container = ProviderContainer(
      overrides: [postStoreProvider.overrideWithValue(MemoryPostStore())],
    );
    addTearDown(container.dispose);

    await container.read(feedPostsProvider.notifier).create(
          FeedPost(
            id: 'p1',
            authorName: 'Angga',
            title: 'Sunset Run',
            caption: 'Great 5K session',
            createdAt: DateTime(2026, 11, 27),
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: HomePostsSection())),
        ),
      ),
    );

    expect(find.text('Sunset Run'), findsOneWidget);
    expect(find.text('0 likes'), findsOneWidget);

    await tester.tap(find.text('0 likes'));
    await tester.pumpAndSettle();
    expect(find.text('1 likes'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete Sunset Run'));
    await tester.pumpAndSettle();
    expect(find.text('No posts yet'), findsOneWidget);
  });
}