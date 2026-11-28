import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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

  void _openComments(BuildContext context, WidgetRef ref, FeedPost post) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: Consumer(
          builder: (context, innerRef, _) {
            final latest = innerRef
                .watch(feedPostsProvider)
                .firstWhere((p) => p.id == post.id, orElse: () => post);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comments (${latest.comments.length})',
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                if (latest.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No comments yet. Be the first to cheer!',
                      style: TextStyle(color: Styles.textSecondary),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: latest.comments.length,
                      itemBuilder: (_, i) {
                        final comment = latest.comments[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${comment.authorName} • ${comment.createdAt.timeAgo()}',
                                style: const TextStyle(
                                  color: Styles.primaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                comment.text,
                                style: const TextStyle(
                                  color: Styles.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Styles.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: const TextStyle(color: Styles.textMuted),
                          filled: true,
                          fillColor: Styles.fieldFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Styles.border),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Styles.primary,
                        foregroundColor: Styles.textPrimary,
                      ),
                      icon: const Icon(Icons.send_rounded, size: 18),
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        String author = 'Stride Athlete';
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          final name = user?.displayName?.trim();
                          if (name != null && name.isNotEmpty) author = name;
                        } catch (_) {}
                        innerRef.read(feedPostsProvider.notifier).addComment(
                              latest.id,
                              FeedComment(
                                id: 'c_${DateTime.now().microsecondsSinceEpoch}',
                                authorName: author,
                                text: text,
                                createdAt: DateTime.now(),
                              ),
                            );
                        controller.clear();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
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
                borderRadius: BorderRadius.circular(18),
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
                onComment: () => _openComments(context, ref, post),
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
  final VoidCallback onComment;
  final VoidCallback onDelete;

  const _FeedPostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onDelete,
  });

  Widget _buildAuthorAvatar() {
    final photo = post.authorPhotoUrl?.trim();
    if (photo != null &&
        (photo.startsWith('http://') || photo.startsWith('https://'))) {
      return ClipOval(
        child: Image.network(
          photo,
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _initials(),
        ),
      );
    }
    return _initials();
  }

  Widget _initials() {
    return CircleAvatar(
      radius: 19,
      backgroundColor: Styles.surfaceHighlight,
      foregroundColor: Styles.primaryLight,
      child: Text(
        post.authorName.isEmpty ? 'S' : post.authorName[0].toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = post.imagePath;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Styles.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAuthorAvatar(),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Styles.surfaceHighlight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  post.tag,
                  style: const TextStyle(
                    color: Styles.primaryLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
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
          const SizedBox(height: 12),
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
              height: 1.45,
            ),
          ),
          if (imagePath != null && imagePath.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(imagePath),
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: Styles.divider, height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color:
                            post.isLiked ? Styles.danger : Styles.textSecondary,
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
              const SizedBox(width: 16),
              InkWell(
                onTap: onComment,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 17,
                        color: Styles.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.comments.length} comments',
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
        ],
      ),
    );
  }
}