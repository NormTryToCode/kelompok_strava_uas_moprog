import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/post_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/post_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_posts/widgets/post_tag_picker.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/widgets/club_avatar.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/choice_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/sheet_handle.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  final Club club;
  final bool pickPhotoOnOpen;

  const CreatePostPage({
    super.key,
    required this.club,
    this.pickPhotoOnOpen = false,
  });

  static Future<ClubPost?> open(
    BuildContext context,
    Club club, {
    bool pickPhotoOnOpen = false,
  }) {
    return Navigator.of(context, rootNavigator: true).push<ClubPost>(
      MaterialPageRoute<ClubPost>(
        builder: (_) =>
            CreatePostPage(club: club, pickPhotoOnOpen: pickPhotoOnOpen),
      ),
    );
  }

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _picker = ImagePicker();

  PostAuthorRole _authorRole = PostAuthorRole.club;
  PostTag _tag = PostTag.general;
  bool _allowComments = true;
  String? _imagePath;
  bool _saving = false;

  String get _authorName =>
      _authorRole == PostAuthorRole.club ? widget.club.name : 'You';

  bool get _canPublish {
    final hasText =
        _titleController.text.trim().isNotEmpty ||
        _bodyController.text.trim().isNotEmpty;
    return (hasText || _imagePath != null) && !_saving;
  }

  @override
  void initState() {
    super.initState();
    if (widget.pickPhotoOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickPhoto());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      setState(() => _imagePath = file.path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not pick photo right now.')),
      );
    }
  }

  Future<void> _pickAuthorRole() async {
    final selected = await showModalBottomSheet<PostAuthorRole>(
      context: context,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SheetHandle(margin: EdgeInsets.zero),
                const SizedBox(height: 16),
                const Text(
                  'Posting as',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (
                        var i = 0;
                        i < PostAuthorRole.values.length;
                        i++
                      ) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceCard(
                            icon: PostAuthorRole.values[i].icon,
                            title:
                                PostAuthorRole.values[i] == PostAuthorRole.club
                                ? widget.club.name
                                : 'You',
                            subtitle: PostAuthorRole.values[i].subtitle,
                            selected: PostAuthorRole.values[i] == _authorRole,
                            onTap: () =>
                                Navigator.of(sheetContext)
                                    .pop(PostAuthorRole.values[i]),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() => _authorRole = selected);
    }
  }

  Future<void> _onPublish() async {
    if (!_canPublish) return;
    setState(() => _saving = true);

    try {
      final created = await ref
          .read(clubPostsProvider(widget.club.id).notifier)
          .createPost(
            authorName: _authorName,
            authorRole: _authorRole,
            title: _titleController.text,
            body: _bodyController.text,
            tag: _tag,
            imagePath: _imagePath,
            allowComments: _allowComments,
          );
      if (!mounted) return;
      Navigator.of(context).pop(created);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not publish post. Please try again.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration({required String hint}) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.field),
      borderSide: BorderSide(color: color, width: width),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Styles.surfaceHighlight),
      filled: true,
      fillColor: Styles.fieldFill,
      counterStyle: const TextStyle(
        color: Styles.surfaceHighlight,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: border(Styles.cardBorder, 1.2),
      focusedBorder: border(Styles.teal, 1.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _imagePath;

    return Scaffold(
      backgroundColor: Styles.canvas,
      body: Column(
        children: [
          _Header(
            clubName: widget.club.name,
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoftCard(
                    onTap: _pickAuthorRole,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    radius: 18,
                    child: Row(
                      children: [
                        if (_authorRole == PostAuthorRole.club)
                          ClubAvatar(club: widget.club, size: 44)
                        else
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Styles.selectedFill,
                              border: Border.all(
                                color: Styles.teal,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Styles.teal,
                              size: 22,
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Posting as',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Styles.surfaceHighlight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _authorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _pickAuthorRole,
                          style: TextButton.styleFrom(
                            foregroundColor: Styles.accent,
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Topic',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PostTagPicker(
                    selected: _tag,
                    onChanged: (value) => setState(() => _tag = value),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _titleController,
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Styles.teal,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    decoration: _inputDecoration(hint: 'Add a headline'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bodyController,
                    maxLength: 600,
                    minLines: 5,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Styles.teal,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      color: Colors.white,
                    ),
                    decoration: _inputDecoration(
                      hint: 'Write something for the club...',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (imagePath != null) ...[
                    const SizedBox(height: 14),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(imagePath),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.black.withAlpha(160),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => setState(() => _imagePath = null),
                              child: const SizedBox(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  SoftCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    radius: 16,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Allow comments',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Let members reply to this post',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Styles.surfaceHighlight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _allowComments,
                          onChanged: (value) =>
                              setState(() => _allowComments = value),
                          thumbColor: WidgetStateProperty.all(Colors.white),
                          trackColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? Styles.teal
                                : Styles.surfaceHighlight,
                          ),
                          trackOutlineColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Styles.canvas,
              border: Border(top: BorderSide(color: Styles.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Material(
                      color: Styles.fieldFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.button),
                        side: const BorderSide(color: Styles.cardBorder),
                      ),
                      child: InkWell(
                        onTap: _pickPhoto,
                        borderRadius: BorderRadius.circular(Radii.button),
                        child: const SizedBox(
                          width: 54,
                          height: 54,
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Styles.teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: _saving ? 'Publishing...' : 'Publish post',
                        onPressed: _canPublish ? _onPublish : null,
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
  }
}

class _Header extends StatelessWidget {
  final String clubName;
  final VoidCallback onClose;

  const _Header({required this.clubName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.canvas,
        border: Border(
          bottom: BorderSide(color: Styles.cardBorder, width: 0.8),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 14),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Post',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'in $clubName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Styles.surfaceHighlight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

