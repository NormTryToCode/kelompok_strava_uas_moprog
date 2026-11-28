import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok_strava_uas_moprog/core/database/storage_user_id.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

const List<String> _postTags = [
  'Running',
  'Cycling',
  'Trail',
  'Workout',
  'Milestone',
];

class CreateFeedPostPage extends ConsumerStatefulWidget {
  final String? initialImagePath;

  const CreateFeedPostPage({super.key, this.initialImagePath});

  @override
  ConsumerState<CreateFeedPostPage> createState() => _CreateFeedPostPageState();
}

class _CreateFeedPostPageState extends ConsumerState<CreateFeedPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _caption = TextEditingController();
  final _picker = ImagePicker();
  late String? _imagePath = widget.initialImagePath;
  String _selectedTag = _postTags.first;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _caption.dispose();
    super.dispose();
  }

  String _resolveAuthorName() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final name = user?.displayName?.trim();
      if (name != null && name.isNotEmpty) return name;
      final emailPrefix = user?.email?.split('@').first.trim();
      if (emailPrefix != null && emailPrefix.isNotEmpty) return emailPrefix;
    } catch (_) {}
    return 'Stride Athlete';
  }

  String? _resolveAuthorPhoto() {
    try {
      final url = FirebaseAuth.instance.currentUser?.photoURL?.trim();
      if (url != null && url.isNotEmpty) return url;
    } catch (_) {}
    return null;
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null && mounted) {
        setState(() => _imagePath = picked.path);
      }
    } catch (_) {
      return;
    }
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Styles.textSecondary),
      hintStyle: const TextStyle(color: Styles.textMuted),
      filled: true,
      fillColor: Styles.fieldFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Styles.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Styles.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Styles.primary, width: 1.5),
      ),
    );
  }

  Future<void> _publish() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final post = FeedPost(
      id: 'post_${DateTime.now().microsecondsSinceEpoch}',
      authorId: resolveStorageUserId(),
      authorName: _resolveAuthorName(),
      authorPhotoUrl: _resolveAuthorPhoto(),
      title: _title.text.trim(),
      caption: _caption.text.trim(),
      tag: _selectedTag,
      imagePath: _imagePath,
      createdAt: DateTime.now(),
    );

    await ref.read(feedPostsProvider.notifier).create(post);
    ref.read(notificationsProvider.notifier).addNotification(
          title: 'New post published',
          body: post.title,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post published to Home feed')),
    );
    Navigator.of(context).maybePop(post);
  }

  @override
  Widget build(BuildContext context) {
    final author = _resolveAuthorName();
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: const AppHeader(title: 'Create Post', showBackButton: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Styles.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Styles.surfaceHighlight,
                    foregroundColor: Styles.primaryLight,
                    child: Text(
                      author.isEmpty ? 'S' : author[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: const TextStyle(
                            color: Styles.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          'Public • Stride Community Feed',
                          style: TextStyle(
                            color: Styles.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CATEGORY',
              style: TextStyle(
                color: Styles.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in _postTags)
                  ChoiceChip(
                    label: Text(tag),
                    selected: _selectedTag == tag,
                    selectedColor: Styles.primary,
                    backgroundColor: Styles.surface,
                    labelStyle: TextStyle(
                      color: _selectedTag == tag
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _selectedTag = tag),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Styles.border),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    style: const TextStyle(
                      color: Styles.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: _decoration(
                      'Headline',
                      hint: 'Evening 5K around Senayan',
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Enter a post title' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _caption,
                    maxLines: 4,
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _decoration(
                      'Story',
                      hint: 'Share how your session felt today...',
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Write a short story' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_imagePath != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(_imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => _imagePath = null),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Styles.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Styles.borderStrong),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: Styles.primaryLight,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Attach a workout photo (optional)',
                      style: TextStyle(
                        color: Styles.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.gallery),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Styles.primaryLight,
                              side: const BorderSide(color: Styles.borderStrong),
                            ),
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 18,
                            ),
                            label: const Text('Gallery'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.camera),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Styles.primaryLight,
                              side: const BorderSide(color: Styles.borderStrong),
                            ),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                            ),
                            label: const Text('Camera'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: FilledButton.icon(
                onPressed: _saving ? null : _publish,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Styles.canvas,
                  minimumSize: const Size.fromHeight(52),
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _saving ? 'Publishing...' : 'Publish Post',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}