import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_picker_field.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_pickers.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/recurrence_settings.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class EventScheduleFields extends StatelessWidget {
  final EventFormController controller;

  const EventScheduleFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final dateError = controller.showErrors ? controller.dateError : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const EventFieldLabel('Date'),
                      const SizedBox(height: 8),
                      EventPickerField(
                        value: formatDate(controller.date),
                        onTap: () async {
                          final picked =
                              await pickEventDate(context, controller.date);
                          if (picked != null) {
                            controller.update(() => controller.date = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const EventFieldLabel('Time'),
                      const SizedBox(height: 8),
                      EventPickerField(
                        value: formatTime(controller.time),
                        onTap: () async {
                          final picked =
                              await pickEventTime(context, controller.time);
                          if (picked != null) {
                            controller.update(() => controller.time = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (dateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  dateError,
                  style: const TextStyle(fontSize: 13, color: eventErrorColor),
                ),
              ),
            const SizedBox(height: 16),
            EventToggleTile(
              title: 'Repeat',
              subtitle: controller.recurring
                  ? controller.recurrenceSummary
                  : 'One-time event',
              value: controller.recurring,
              onChanged: (value) =>
                  controller.update(() => controller.recurring = value),
            ),
            if (controller.recurring) ...[
              const SizedBox(height: 16),
              RecurrenceSettings(controller: controller),
            ],
          ],
        );
      },
    );
  }
}
