import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/club_photo_picker.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_heading.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class Step3ClubDetails extends StatelessWidget {
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

  InputDecoration _decoration(String label) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Styles.tabInactive),
      floatingLabelStyle: const TextStyle(color: Palette.teal),
      alignLabelWithHint: true,
      filled: true,
      fillColor: Palette.fieldFill,
      counterStyle: const TextStyle(color: Styles.tabInactive),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: border(Palette.cardBorder, 1.2),
      focusedBorder: border(Palette.teal, 1.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeading(
            eyebrow: 'Details',
            title: 'Give your club an identity',
            subtitle: 'Add a name, a photo, and a short description.',
          ),
          const SizedBox(height: 28),
          Center(child: ClubPhotoPicker(onTap: onPickPhoto)),
          const SizedBox(height: 28),
          TextFormField(
            initialValue: name,
            onChanged: onNameChanged,
            maxLength: 40,
            textCapitalization: TextCapitalization.words,
            cursorColor: Palette.teal,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: _decoration('Club name'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: description,
            onChanged: onDescriptionChanged,
            maxLength: 200,
            minLines: 4,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Palette.teal,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            decoration: _decoration('Description (optional)'),
          ),
          const SizedBox(height: 14),
          const SoftCard(
            padding: EdgeInsets.all(14),
            radius: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_user_outlined, size: 18, color: Palette.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Keep it friendly. Names and descriptions must follow our community guidelines.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Styles.tabInactive,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
