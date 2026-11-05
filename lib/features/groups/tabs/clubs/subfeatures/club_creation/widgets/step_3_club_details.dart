import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/club_photo_picker.dart';

class Step3ClubDetails extends StatefulWidget {
  final String name;
  final String description;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final VoidCallback onPickPhoto;

  const Step3ClubDetails({
    super.key,
    required this.name,
    required this.description,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onPickPhoto,
  });

  @override
  State<Step3ClubDetails> createState() => _Step3ClubDetailsState();
}

class _Step3ClubDetailsState extends State<Step3ClubDetails> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.name);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.description);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Styles.tabInactive),
      floatingLabelStyle: const TextStyle(color: Styles.accent),
      alignLabelWithHint: true,
      counterStyle: const TextStyle(color: Styles.tabInactive),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: border(Styles.inactive, 1.5),
      focusedBorder: border(Styles.accent, 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set up your club',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a name, a photo, and a short description.',
            style: TextStyle(fontSize: 16, color: Styles.tabInactive),
          ),
          const SizedBox(height: 28),
          Center(child: ClubPhotoPicker(onTap: widget.onPickPhoto)),
          const SizedBox(height: 28),
          TextField(
            controller: _nameController,
            onChanged: widget.onNameChanged,
            maxLength: 40,
            textCapitalization: TextCapitalization.words,
            cursorColor: Styles.accent,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: _decoration('Club name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            onChanged: widget.onDescriptionChanged,
            maxLength: 200,
            minLines: 4,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Styles.accent,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: _decoration('Description (optional)'),
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 20, color: Styles.tabInactive),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Keep it friendly. Names and descriptions must follow our community guidelines.',
                  style: TextStyle(fontSize: 13, color: Styles.tabInactive),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
