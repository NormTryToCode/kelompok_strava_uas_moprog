import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';

class EventDescriptionFields extends StatelessWidget {
  final EventFormController controller;

  const EventDescriptionFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EventFieldLabel('Description', tag: FieldTag.optional),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: controller.description,
              minLines: 4,
              maxLines: 6,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Colors.white,
              style: eventFieldTextStyle,
              decoration: eventInputDecoration(hint: 'Tell people what to expect'),
              onChanged: (value) =>
                  controller.update(() => controller.description = value),
            ),
            const SizedBox(height: 20),
            EventToggleTile(
              title: 'Show in search',
              subtitle: 'Let people find this event in search and recommendations',
              value: controller.discoverable,
              onChanged: (value) =>
                  controller.update(() => controller.discoverable = value),
            ),
          ],
        );
      },
    );
  }
}
