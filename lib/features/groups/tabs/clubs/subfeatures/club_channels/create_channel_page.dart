import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/channel_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/widgets/channel_category_picker.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/widgets/channel_preview_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/choice_card.dart';

class CreateChannelPage extends ConsumerStatefulWidget {
  final Club club;

  const CreateChannelPage({super.key, required this.club});

  static Future<ClubChannel?> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<ClubChannel>(
      MaterialPageRoute<ClubChannel>(
        builder: (_) => CreateChannelPage(club: club),
      ),
    );
  }

  @override
  ConsumerState<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends ConsumerState<CreateChannelPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  ChannelCategory _category = ChannelCategory.discussion;
  ChannelMembership _membership = ChannelMembership.everyone;
  ChannelPostPermission _postPermission = ChannelPostPermission.everyone;
  bool _saving = false;

  bool get _canSubmit => _nameController.text.trim().isNotEmpty && !_saving;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String hint,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Styles.tabInactive),
      filled: true,
      fillColor: Palette.fieldFill,
      counterStyle: const TextStyle(color: Styles.tabInactive, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border(Palette.cardBorder, 1.2),
      focusedBorder: border(Palette.teal, 1.8),
    );
  }

  Future<void> _onCreate() async {
    if (!_canSubmit) return;
    setState(() => _saving = true);

    try {
      final created = await ref
          .read(clubChannelsProvider(widget.club.id).notifier)
          .createChannel(
            name: _nameController.text,
            description: _descriptionController.text,
            category: _category,
            membership: _membership,
            postPermission: _postPermission,
          );
      if (!mounted) return;
      Navigator.of(context).pop(created);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not create the channel. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          _Header(
            clubName: widget.club.name,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChannelPreviewCard(
                    name: _nameController.text,
                    description: _descriptionController.text,
                    category: _category,
                    membership: _membership,
                    postPermission: _postPermission,
                  ),
                  const SizedBox(height: 24),
                  const _FieldHeader(label: 'Channel name', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    maxLength: 40,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Palette.teal,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: _fieldDecoration(hint: 'Name your channel'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  const _FieldHeader(label: 'Channel description'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLength: 160,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Palette.teal,
                    style: const TextStyle(fontSize: 15.5, color: Colors.white),
                    decoration: _fieldDecoration(
                      hint: 'Write a brief description about your channel',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 18),
                  const _FieldHeader(label: 'Category'),
                  const SizedBox(height: 10),
                  ChannelCategoryPicker(
                    selected: _category,
                    onChanged: (value) => setState(() => _category = value),
                  ),
                  const SizedBox(height: 24),
                  const _FieldHeader(label: 'Who\u2019s in the channel?'),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0;
                            i < ChannelMembership.values.length;
                            i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ChoiceCard(
                              icon: ChannelMembership.values[i].icon,
                              title: ChannelMembership.values[i].title,
                              subtitle: ChannelMembership.values[i].subtitle,
                              selected:
                                  ChannelMembership.values[i] == _membership,
                              onTap: () => setState(
                                () => _membership = ChannelMembership.values[i],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _FieldHeader(label: 'Who can post?'),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0;
                            i < ChannelPostPermission.values.length;
                            i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ChoiceCard(
                              icon: ChannelPostPermission.values[i].icon,
                              title: ChannelPostPermission.values[i].title,
                              subtitle:
                                  ChannelPostPermission.values[i].subtitle,
                              selected: ChannelPostPermission.values[i] ==
                                  _postPermission,
                              onTap: () => setState(
                                () => _postPermission =
                                    ChannelPostPermission.values[i],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Styles.background,
              border: Border(top: BorderSide(color: Palette.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: _saving ? 'Creating...' : 'Create channel',
                      onPressed: _canSubmit ? _onCreate : null,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Settings can be changed at any time.',
                      style: TextStyle(fontSize: 12.5, color: Styles.tabInactive),
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
  final VoidCallback onBack;

  const _Header({required this.clubName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Styles.background,
        border: Border(
          bottom: BorderSide(color: Palette.cardBorder, width: 0.8),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 14),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create channel',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'for $clubName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Styles.tabInactive,
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

class _FieldHeader extends StatelessWidget {
  final String label;
  final bool required;

  const _FieldHeader({required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        if (required)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Styles.accent.withAlpha(34),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Required',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Styles.accent,
              ),
            ),
          )
        else
          const Text(
            'Optional',
            style: TextStyle(fontSize: 12, color: Styles.tabInactive),
          ),
      ],
    );
  }
}