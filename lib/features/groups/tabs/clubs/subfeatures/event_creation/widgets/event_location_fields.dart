import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/location_search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_picker_field.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';

class EventLocationFields extends StatelessWidget {
  final EventFormController controller;

  const EventLocationFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventFieldLabel(
              'Meeting point',
              tag: controller.isVirtual ? FieldTag.none : FieldTag.required,
            ),
            const SizedBox(height: 8),
            EventPickerField(
              value: controller.location?.name,
              placeholder: 'Choose a location',
              enabled: !controller.isVirtual,
              trailing: const Icon(Icons.search, color: Styles.tabInactive),
              errorText:
                  controller.showErrors ? controller.locationError : null,
              onTap: () async {
                final picked = await LocationSearchPage.open(context);
                if (picked != null) {
                  controller.update(() => controller.location = picked);
                }
              },
            ),
            const SizedBox(height: 16),
            EventToggleTile(
              title: 'Online event',
              subtitle: 'No physical meeting point',
              value: controller.isVirtual,
              onChanged: (value) =>
                  controller.update(() => controller.isVirtual = value),
            ),
          ],
        );
      },
    );
  }
}
