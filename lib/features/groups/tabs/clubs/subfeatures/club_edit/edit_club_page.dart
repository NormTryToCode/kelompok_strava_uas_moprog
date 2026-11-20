import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/location_search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_edit/widgets/club_edit_pickers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_edit/widgets/club_media_editor.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/choice_card.dart';

class EditClubPage extends ConsumerStatefulWidget {
  final Club club;

  const EditClubPage({super.key, required this.club});

  static Future<Club?> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<Club>(
      MaterialPageRoute<Club>(builder: (_) => EditClubPage(club: club)),
    );
  }

  @override
  ConsumerState<EditClubPage> createState() => _EditClubPageState();
}

class _EditClubPageState extends ConsumerState<EditClubPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _vanityUrlController;
  final _picker = ImagePicker();

  late ClubSport _sport;
  late List<ClubType> _types;
  late ClubPrivacy _privacy;
  late bool _isGlobal;
  ClubLocation? _location;
  String? _avatarPath;
  String? _coverPath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.club;
    _nameController = TextEditingController(text: c.name);
    _descriptionController = TextEditingController(text: c.description);
    _vanityUrlController = TextEditingController(text: c.vanityUrl ?? '');
    _sport = c.sport;
    _types = List<ClubType>.of(c.types);
    _privacy = c.privacy;
    _isGlobal = c.isGlobal;
    _location = c.location;
    _avatarPath = c.avatarPath;
    _coverPath = c.coverPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _vanityUrlController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty && _types.isNotEmpty && !_saving;

  Club get _previewClub => widget.club.copyWith(
        name: _nameController.text.trim().isEmpty
            ? widget.club.name
            : _nameController.text.trim(),
        avatarPath: _avatarPath,
        clearAvatar: _avatarPath == null,
        coverPath: _coverPath,
        clearCover: _coverPath == null,
      );

  String get _locationDisplay {
    final loc = _location;
    if (_isGlobal || loc == null) return 'Global';
    return loc.detail.isEmpty ? loc.name : '${loc.name}, ${loc.detail}';
  }

  Future<void> _pickImage({required bool isCover}) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() {
        if (isCover) {
          _coverPath = picked.path;
        } else {
          _avatarPath = picked.path;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not pick image right now.')),
      );
    }
  }

  Future<void> _pickSport() async {
    final picked = await showClubSportPickerSheet(context, selected: _sport);
    if (picked != null && mounted) {
      setState(() => _sport = picked);
    }
  }

  Future<void> _pickTypes() async {
    final picked = await showClubTypePickerSheet(
      context,
      initialSelected: _types,
    );
    if (picked != null && mounted) {
      setState(() => _types = picked);
    }
  }

  Future<void> _pickLocation() async {
    final picked = await LocationSearchPage.open(context);
    if (picked != null && mounted) {
      setState(() {
        _isGlobal = false;
        _location = picked;
      });
    }
  }

  void _resetLocationToGlobal() {
    setState(() {
      _isGlobal = true;
      _location = null;
    });
  }

  Future<void> _onSave() async {
    if (!_canSave) return;
    setState(() => _saving = true);

    final slug = _vanityUrlController.text.trim();
    final updated = widget.club.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      sport: _sport,
      types: _types,
      privacy: _privacy,
      isGlobal: _isGlobal,
      location: _isGlobal ? null : _location,
      clearLocation: _isGlobal,
      avatarPath: _avatarPath,
      clearAvatar: _avatarPath == null,
      coverPath: _coverPath,
      clearCover: _coverPath == null,
      vanityUrl: slug.isEmpty ? null : slug,
      clearVanityUrl: slug.isEmpty,
    );

    try {
      await ref.read(clubsProvider.notifier).updateClub(updated);
      if (!mounted) return;
      Navigator.of(context).pop(updated);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save changes. Please try again.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      prefixStyle: const TextStyle(fontSize: 15, color: Styles.tabInactive),
      labelStyle: const TextStyle(color: Styles.tabInactive),
      floatingLabelStyle: const TextStyle(color: Palette.teal),
      hintStyle: const TextStyle(color: Styles.tabInactive),
      alignLabelWithHint: true,
      filled: true,
      fillColor: Palette.fieldFill,
      counterStyle: const TextStyle(color: Styles.tabInactive, fontSize: 12),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border(Palette.cardBorder, 1.2),
      focusedBorder: border(Palette.teal, 1.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = _types.map((t) => t.name).join(' \u00b7 ');

    return Scaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          _Header(
            onBack: () => Navigator.of(context).pop(),
            canSave: _canSave,
            saving: _saving,
            onSave: _onSave,
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClubMediaEditor(
                    previewClub: _previewClub,
                    onPickCover: () => _pickImage(isCover: true),
                    onPickAvatar: () => _pickImage(isCover: false),
                    onRemoveCover: _coverPath == null
                        ? null
                        : () => setState(() => _coverPath = null),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    maxLength: 40,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Palette.teal,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: _inputDecoration(label: 'Club Name'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _PickerField(
                    label: 'Sport',
                    value: _sport.name,
                    leadingIcon: _sport.icon,
                    onTap: _pickSport,
                  ),
                  const SizedBox(height: 16),
                  _PickerField(
                    label: 'Club Type',
                    value: typeLabel.isEmpty ? 'Select club type' : typeLabel,
                    placeholder: typeLabel.isEmpty,
                    onTap: _pickTypes,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLength: 200,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Palette.teal,
                    style: const TextStyle(fontSize: 15.5, color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Description',
                      hint: 'Tell people what your club is about',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Privacy',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < ClubPrivacy.option.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ChoiceCard(
                              icon: ClubPrivacy.option[i].id ==
                                      ClubPrivacy.private.id
                                  ? Icons.lock_outline
                                  : Icons.public,
                              title: ClubPrivacy.option[i].name,
                              subtitle: ClubPrivacy.option[i].description,
                              selected: ClubPrivacy.option[i].id == _privacy.id,
                              onTap: () => setState(
                                () => _privacy = ClubPrivacy.option[i],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PickerField(
                    label: 'Location',
                    value: _locationDisplay,
                    leadingIcon:
                        _isGlobal ? Icons.public : Icons.place_outlined,
                    trailing: _isGlobal
                        ? const Icon(
                            Icons.search,
                            color: Styles.tabInactive,
                            size: 20,
                          )
                        : IconButton(
                            onPressed: _resetLocationToGlobal,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Styles.tabInactive,
                              size: 20,
                            ),
                            tooltip: 'Reset to Global',
                          ),
                    onTap: _pickLocation,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _vanityUrlController,
                    maxLength: 32,
                    cursorColor: Palette.teal,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
                    ],
                    style: const TextStyle(fontSize: 15.5, color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Vanity URL',
                      hint: 'your-club-name',
                      prefixText: 'strava.com/clubs/',
                      suffixIcon: _vanityUrlController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _vanityUrlController.clear();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Styles.tabInactive,
                                size: 20,
                              ),
                            ),
                    ),
                    onChanged: (_) => setState(() {}),
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
                child: PrimaryButton(
                  label: _saving ? 'Saving...' : 'Save changes',
                  onPressed: _canSave ? _onSave : null,
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
  final VoidCallback onBack;
  final bool canSave;
  final bool saving;
  final VoidCallback onSave;

  const _Header({
    required this.onBack,
    required this.canSave,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF123B3A), Styles.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Edit Club',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: canSave ? onSave : null,
                style: TextButton.styleFrom(
                  foregroundColor: Palette.teal,
                  disabledForegroundColor: Styles.tabInactive.withAlpha(90),
                ),
                child: Text(
                  saving ? 'SAVING' : 'SAVE',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool placeholder;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.leadingIcon,
    this.trailing,
    this.placeholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Styles.tabInactive,
            ),
          ),
        ),
        Material(
          color: Palette.fieldFill,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.field),
            side: const BorderSide(color: Palette.cardBorder, width: 1.2),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 54,
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: 20, color: Palette.teal),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: placeholder ? Styles.tabInactive : Colors.white,
                        ),
                      ),
                    ),
                    trailing ??
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Styles.tabInactive,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}