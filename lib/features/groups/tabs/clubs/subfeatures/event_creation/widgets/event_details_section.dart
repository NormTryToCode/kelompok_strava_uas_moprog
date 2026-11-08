import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/radio_dot.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_form_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/pace_editor.dart';

class EventDetailsSection extends StatelessWidget {
  final EventFormController controller;

  const EventDetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final kindError = controller.showErrors ? controller.kindError : null;
        final paceError = controller.showErrors ? controller.paceError : null;

        return EventFormSection(
          title: 'Event details',
          subtitle: 'Choose the event type and pace groups',
          forceExpanded: kindError != null || paceError != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EventFieldLabel('Event type', tag: FieldTag.required),
              const SizedBox(height: 4),
              for (final kind in EventKind.option)
                _KindTile(
                  kind: kind,
                  selected: controller.kind?.id == kind.id,
                  onTap: () => controller.update(() => controller.kind = kind),
                ),
              if (kindError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4),
                  child: Text(
                    kindError,
                    style: const TextStyle(fontSize: 13, color: eventErrorColor),
                  ),
                ),
              const SizedBox(height: 16),
              EventToggleTile(
                title: 'Pace groups',
                subtitle: 'Set speed ranges for each group',
                value: controller.paceEnabled,
                onChanged: controller.setPaceEnabled,
              ),
              if (controller.paceEnabled) ...[
                const SizedBox(height: 16),
                PaceEditor(controller: controller),
                if (paceError != null && controller.paceRanges.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      paceError,
                      style: const TextStyle(fontSize: 13, color: eventErrorColor),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _KindTile extends StatelessWidget {
  final EventKind kind;
  final bool selected;
  final VoidCallback onTap;

  const _KindTile({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(kind.icon, size: 30, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kind.name,
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  Text(
                    kind.description,
                    style: const TextStyle(fontSize: 14, color: Styles.tabInactive),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            RadioDot(selected: selected),
          ],
        ),
      ),
    );
  }
}
