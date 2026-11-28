import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/extensions/date_time_extensions.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/create_feed_post_page.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';

class HomePostsSection extends ConsumerWidget {
  const HomePostsSection({super.key});

  void _openCreatePost(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CreateFeedPostPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Community Feed',
                  style: TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _openCreatePost(context),
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 18,
                  color: Styles.primaryLight,
                ),
                label: const Text(
                  'New Post',
                  style: TextStyle(
                    color: Styles.primaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (posts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Styles.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'No posts yet',
                    style: TextStyle(
                      color: Styles.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Share your workout story or photo with the Stride community.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Styles.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: () => _openCreatePost(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Styles.primary,
                      foregroundColor: Styles.textPrimary,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Create Post'),
                  ),
                ],
              ),
            )
          else
            for (final post in posts)
              _FeedPostCard(
                post: post,
                onLike: () =>
                    ref.read(feedPostsProvider.notifier).toggleLike(post.id),
                onDelete: () =>
                    ref.read(feedPostsProvider.notifier).remove(post.id),
              ),
        ],
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final VoidCallback onLike;
  final VoidCallback onDelete;

  const _FeedPostCard({
    required this.post,
    required this.onLike,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = post.imagePath;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Styles.surfaceHighlight,
                foregroundColor: Styles.primaryLight,
                child: Text(
                  post.authorName.isEmpty
                      ? 'S'
                      : post.authorName[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        color: Styles.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      post.createdAt.timeAgo(),
                      style: const TextStyle(
                        color: Styles.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete ${post.title}',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Styles.textMuted,
                  size: 20,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.title,
            style: const TextStyle(
              color: Styles.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.caption,
            style: const TextStyle(
              color: Styles.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (imagePath != null && imagePath.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ],
          const SizedBox(height: 10),
          InkWell(
            onTap: onLike,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: post.isLiked ? Styles.danger : Styles.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${post.likes} likes',
                    style: const TextStyle(
                      color: Styles.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}