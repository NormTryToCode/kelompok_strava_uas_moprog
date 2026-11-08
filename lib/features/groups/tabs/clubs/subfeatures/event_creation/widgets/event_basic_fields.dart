import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_picker_field.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/sport_picker_sheet.dart';

class EventBasicFields extends StatelessWidget {
  final EventFormController controller;

  const EventBasicFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final sport = controller.sport;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EventFieldLabel('Event name', tag: FieldTag.required),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: controller.name,
              maxLength: EventFormController.maxNameLength,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Colors.white,
              style: eventFieldTextStyle,
              decoration: eventInputDecoration(
                helper: '3 to 125 characters',
                errorText:
                    controller.showErrors ? controller.nameError : null,
              ),
              onChanged: (value) =>
                  controller.update(() => controller.name = value),
            ),
            const SizedBox(height: 20),
            EventFieldLabel(
              'Sport',
              tag: controller.skipSport ? FieldTag.none : FieldTag.required,
            ),
            const SizedBox(height: 8),
            EventPickerField(
              value: sport?.name,
              placeholder: 'Choose a sport',
              leadingIcon: sport?.icon,
              enabled: !controller.skipSport,
              errorText: controller.showErrors ? controller.sportError : null,
              onTap: () async {
                final picked =
                    await showSportPickerSheet(context, selected: sport);
                if (picked != null) {
                  controller.update(() => controller.sport = picked);
                }
              },
            ),
            const SizedBox(height: 16),
            EventToggleTile(
              title: 'No specific sport',
              subtitle: 'Not tied to any one sport',
              value: controller.skipSport,
              onChanged: (value) =>
                  controller.update(() => controller.skipSport = value),
            ),
          ],
        );
      },
    );
  }
}
