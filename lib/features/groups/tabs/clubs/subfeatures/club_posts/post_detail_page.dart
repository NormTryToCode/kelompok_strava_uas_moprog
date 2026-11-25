import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/post_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/widgets/post_card_item.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/widgets/post_comment_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/confirm_delete_dialog.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Club club;
  final String postId;
  final bool focusComment;

  const PostDetailPage({
    super.key,
    required this.club,
    required this.postId,
    this.focusComment = false,
  });

  static Future<void> open(
    BuildContext context, {
    required Club club,
    required String postId,
    bool focusComment = false,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailPage(
          club: club,
          postId: postId,
          focusComment: focusComment,
        ),
      ),
    );
  }

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.focusComment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _commentFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();
    await ref
        .read(clubPostsProvider(widget.club.id).notifier)
        .addComment(postId: widget.postId, content: text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sharePost(ClubPost post) async {
    final summary = [
      if (post.title.isNotEmpty) post.title,
      if (post.body.isNotEmpty) post.body,
      '— ${post.authorName} (${widget.club.name})',
    ].join('\n');

    await SharePlus.instance.share(
      ShareParams(
        text: summary,
        subject: post.title.isNotEmpty ? post.title : widget.club.name,
      ),
    );
  }

  Future<void> _confirmDeletePost() async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Delete post?',
      message: 'This post and all its comments will be permanently removed.',
    );

    if (!confirmed || !mounted) return;
    await ref
        .read(clubPostsProvider(widget.club.id).notifier)
        .deletePost(widget.postId);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(clubPostsProvider(widget.club.id));

    return postsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Styles.canvas,
        body: Center(child: CircularProgressIndicator(color: Styles.teal)),
      ),
      error: (_, _) => const Scaffold(
        backgroundColor: Styles.canvas,
        body: Center(
          child: Text(
            'Could not load post.',
            style: TextStyle(color: Styles.textSecondary),
          ),
        ),
      ),
      data: (posts) {
        final match = posts.where((p) => p.id == widget.postId);
        if (match.isEmpty) {
          return Scaffold(
            backgroundColor: Styles.canvas,
            appBar: AppBar(
              backgroundColor: Styles.canvas,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text(
                'Post no longer exists.',
                style: TextStyle(color: Styles.textSecondary),
              ),
            ),
          );
        }

        final post = match.first;
        final notifier = ref.read(clubPostsProvider(widget.club.id).notifier);

        return Scaffold(
          backgroundColor: Styles.canvas,
          appBar: AppBar(
            backgroundColor: Styles.canvas,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: const Text(
              'Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                onPressed: () => _sharePost(post),
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share post',
              ),
              IconButton(
                onPressed: _confirmDeletePost,
                icon: const Icon(Icons.delete_outline, color: Styles.accent),
                tooltip: 'Delete post',
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    PostCardItem(
                      club: widget.club,
                      post: post,
                      isDetail: true,
                      onToggleKudos: () => notifier.toggleKudos(post.id),
                      onTapComment: () {
                        if (post.allowComments) {
                          _commentFocusNode.requestFocus();
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    SectionTitle(
                      'Comments',
                      trailing: post.comments.isEmpty
                          ? null
                          : Text(
                              '${post.comments.length}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Styles.teal,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    if (post.comments.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            const IconBubble(
                              Icons.chat_bubble_outline_rounded,
                              size: 52,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              post.allowComments
                                  ? 'No comments yet'
                                  : 'Comments are turned off',
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            if (post.allowComments) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'Start the conversation below.',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Styles.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    else
                      for (var i = 0; i < post.comments.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        PostCommentTile(
                          comment: post.comments[i],
                          onToggleLike: () => notifier.toggleCommentLike(
                            postId: post.id,
                            commentId: post.comments[i].id,
                          ),
                          onDelete: () => notifier.deleteComment(
                            postId: post.id,
                            commentId: post.comments[i].id,
                          ),
                        ),
                      ],
                  ],
                ),
              ),
              if (post.allowComments)
                Container(
                  decoration: const BoxDecoration(
                    color: Styles.surface,
                    border: Border(top: BorderSide(color: Styles.cardBorder)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              focusNode: _commentFocusNode,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _submitComment(),
                              cursorColor: Styles.teal,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: const TextStyle(
                                  color: Styles.textSecondary,
                                ),
                                filled: true,
                                fillColor: Styles.fieldFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                    color: Styles.cardBorder,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                    color: Styles.teal,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color: Styles.accent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _submitComment,
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

