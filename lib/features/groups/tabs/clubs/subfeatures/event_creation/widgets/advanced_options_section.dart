import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_form_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_picker_field.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/option_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';

class AdvancedOptionsSection extends StatelessWidget {
  final EventFormController controller;

  const AdvancedOptionsSection({super.key, required this.controller});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final distanceError =
            controller.showErrors ? controller.distanceError : null;
        final surface = controller.surface;

        return EventFormSection(
          title: 'Advanced options',
          subtitle: 'Route, distance, and surface',
          icon: Icons.alt_route,
          forceExpanded: distanceError != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EventFieldLabel('Route', tag: FieldTag.optional),
              const SizedBox(height: 8),
              const _OutlinedAction(label: 'Add route', onPressed: null),
              const SizedBox(height: 24),
              const EventFieldLabel('Distance', tag: FieldTag.optional),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: controller.distance,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        decimalFormatter(integerDigits: 5, fractionDigits: 2),
                      ],
                      cursorColor: Colors.white,
                      style: eventFieldTextStyle,
                      decoration: eventInputDecoration(
                        hint: '0',
                        errorText: distanceError,
                      ),
                      onChanged: (value) =>
                          controller.update(() => controller.distance = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: EventPickerField(
                      value: controller.distanceUnit.label,
                      onTap: () async {
                        final picked = await showOptionSheet<DistanceUnit>(
                          context,
                          title: 'Distance unit',
                          options: DistanceUnit.values,
                          selected: controller.distanceUnit,
                          labelOf: (u) => u.label,
                        );
                        if (picked != null) {
                          controller
                              .update(() => controller.distanceUnit = picked);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const EventFieldLabel('Surface', tag: FieldTag.optional),
              const SizedBox(height: 8),
              EventPickerField(
                value: surface?.name,
                placeholder: 'Choose a surface',
                trailing: surface == null
                    ? null
                    : GestureDetector(
                        onTap: () =>
                            controller.update(() => controller.surface = null),
                        child: const Icon(Icons.cancel_outlined,
                            color: Colors.white),
                      ),
                onTap: () async {
                  final picked = await showOptionSheet<EventSurface>(
                    context,
                    title: 'Surface',
                    options: EventSurface.option,
                    selected: surface,
                    labelOf: (s) => s.name,
                  );
                  if (picked != null) {
                    controller.update(() => controller.surface = picked);
                  }
                },
              ),
              const SizedBox(height: 24),
              const EventFieldLabel('Co-host', tag: FieldTag.optional, badge: 'New'),
              const SizedBox(height: 8),
              _OutlinedAction(
                label: 'Add co-host',
                onPressed: () => _comingSoon(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _OutlinedAction({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GhostButton(label: label, onPressed: onPressed, height: 50);
  }
}
