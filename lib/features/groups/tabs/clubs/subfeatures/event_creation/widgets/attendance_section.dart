import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_form_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';

class AttendanceSection extends StatelessWidget {
  final EventFormController controller;

  const AttendanceSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final capacityError =
            controller.showErrors ? controller.capacityError : null;

        return EventFormSection(
          title: 'Who can join',
          subtitle: 'Choose who can attend and set a size limit',
          icon: Icons.group_outlined,
          forceExpanded: capacityError != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventToggleTile(
                title: 'Women only',
                value: controller.womenOnly,
                onChanged: (value) =>
                    controller.update(() => controller.womenOnly = value),
              ),
              const SizedBox(height: 20),
              EventToggleTile(
                title: 'Club members only',
                value: controller.clubMembersOnly,
                onChanged: (value) =>
                    controller.update(() => controller.clubMembersOnly = value),
              ),
              const SizedBox(height: 20),
              EventToggleTile(
                title: 'Limit attendees',
                subtitle: 'Cap how many people can join',
                value: controller.capacityEnabled,
                onChanged: (value) =>
                    controller.update(() => controller.capacityEnabled = value),
              ),
              if (controller.capacityEnabled) ...[
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: controller.capacity,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  cursorColor: Colors.white,
                  style: eventFieldTextStyle,
                  decoration: eventInputDecoration(
                    hint: 'Number of attendees',
                    helper: 'From 1 to 100,000',
                    errorText: capacityError,
                  ),
                  onChanged: (value) =>
                      controller.update(() => controller.capacity = value),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
