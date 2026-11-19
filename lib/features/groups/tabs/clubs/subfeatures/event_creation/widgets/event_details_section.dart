import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_form_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_toggle_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/pace_editor.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/selectable_card.dart';

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
          icon: Icons.bolt_outlined,
          forceExpanded: kindError != null || paceError != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EventFieldLabel('Event type', tag: FieldTag.required),
              const SizedBox(height: 10),
              for (final kind in EventKind.option) ...[
                _KindCard(
                  kind: kind,
                  selected: controller.kind?.id == kind.id,
                  onTap: () => controller.update(() => controller.kind = kind),
                ),
                const SizedBox(height: 10),
              ],
              if (kindError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    kindError,
                    style: const TextStyle(fontSize: 13, color: eventErrorColor),
                  ),
                ),
              const SizedBox(height: 6),
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

class _KindCard extends StatelessWidget {
  final EventKind kind;
  final bool selected;
  final VoidCallback onTap;

  const _KindCard({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          IconBubble(
            kind.icon,
            size: 42,
            color: selected ? Palette.teal : Styles.tabInactive,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kind.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    kind.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Styles.tabInactive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
