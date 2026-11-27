import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/feed_posts_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/posts/models/feed_post.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class CreateFeedPostPage extends ConsumerStatefulWidget {
  final bool pickPhotoOnOpen;

  const CreateFeedPostPage({super.key, this.pickPhotoOnOpen = false});

  @override
  ConsumerState<CreateFeedPostPage> createState() => _CreateFeedPostPageState();
}

class _CreateFeedPostPageState extends ConsumerState<CreateFeedPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _caption = TextEditingController();
  final _picker = ImagePicker();
  String? _imagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.pickPhotoOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pickPhoto();
      });
    }
  }

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

  Future<void> _pickPhoto() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
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
      fillColor: Styles.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.primary),
      ),
    );
  }

  Future<void> _publish() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final post = FeedPost(
      id: 'post_${DateTime.now().microsecondsSinceEpoch}',
      authorName: _resolveAuthorName(),
      title: _title.text.trim(),
      caption: _caption.text.trim(),
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
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: const AppHeader(title: 'Create Post', showBackButton: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration(
                'Title',
                hint: 'Evening 5K around Senayan',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Enter a post title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _caption,
              maxLines: 4,
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration(
                'Story',
                hint: 'Share how your session went...',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Write a short story' : null,
            ),
            const SizedBox(height: 16),
            if (_imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(_imagePath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              style: OutlinedButton.styleFrom(
                foregroundColor: Styles.primaryLight,
                side: const BorderSide(color: Styles.borderStrong),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(_imagePath == null ? 'Add Photo' : 'Change Photo'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _publish,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.primary,
                foregroundColor: Styles.textPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: const StadiumBorder(),
              ),
              child: Text(
                _saving ? 'Publishing...' : 'Publish Post',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}