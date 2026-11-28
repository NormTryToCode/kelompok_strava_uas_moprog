import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/post_store.dart';

FeedPost _post(String id, DateTime createdAt) {
  return FeedPost(
    id: id,
    authorName: 'Angga',
    title: 'Post $id',
    caption: 'Caption $id',
    createdAt: createdAt,
  );
}

void main() {
  test('create, toggleLike, dan remove tersimpan di postStoreProvider',
      () async {
    final store = MemoryPostStore();
    final container = ProviderContainer(
      overrides: [postStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(feedPostsProvider.notifier);
    await notifier.create(_post('p1', DateTime(2026, 11, 27, 8)));
    await notifier.create(_post('p2', DateTime(2026, 11, 27, 9)));

    expect(container.read(feedPostsProvider).map((p) => p.id), ['p2', 'p1']);

    await notifier.toggleLike('p2');
    expect(container.read(feedPostsProvider).first.likes, 1);
    expect(container.read(feedPostsProvider).first.isLiked, isTrue);

    await notifier.remove('p1');
    expect(container.read(feedPostsProvider).length, 1);
    expect((await store.readAll()).length, 1);
  });
}