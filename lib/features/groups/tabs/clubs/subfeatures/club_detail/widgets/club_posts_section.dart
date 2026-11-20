import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/post_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/post_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/widgets/post_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubPostsSection extends ConsumerWidget {
  final Club club;

  const ClubPostsSection({super.key, required this.club});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Styles.surface,
        title: const Text(
          'Delete post?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This post and all its comments will be permanently removed.',
          style: TextStyle(color: Styles.tabInactive),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Styles.tabInactive),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Styles.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(clubPostsProvider(club.id).notifier).deletePost(postId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(clubPostsProvider(club.id));
    final count = postsAsync.valueOrNull?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Club posts',
          trailing: count == 0
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.teal.withAlpha(34),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Palette.teal,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        postsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: Palette.teal),
            ),
          ),
          error: (_, _) => const SoftCard(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'Could not load club posts.',
                style: TextStyle(color: Styles.tabInactive),
              ),
            ),
          ),
          data: (posts) {
            if (posts.isEmpty) {
              return const SoftCard(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      IconBubble(Icons.article_outlined, size: 54),
                      SizedBox(height: 12),
                      Text(
                        'No posts yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap "New post" to share a recap, route tip, or update.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final notifier = ref.read(clubPostsProvider(club.id).notifier);

            return Column(
              children: [
                for (var i = 0; i < posts.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  PostCardItem(
                    club: club,
                    post: posts[i],
                    onTapCard: () => PostDetailPage.open(
                      context,
                      club: club,
                      postId: posts[i].id,
                    ),
                    onToggleKudos: () => notifier.toggleKudos(posts[i].id),
                    onTapComment: () => PostDetailPage.open(
                      context,
                      club: club,
                      postId: posts[i].id,
                      focusComment: true,
                    ),
                    onDelete: () => _confirmDelete(context, ref, posts[i].id),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}