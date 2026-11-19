import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_field_label.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_picker_field.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/option_sheet.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/segmented_toggle.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class RecurrenceSettings extends StatelessWidget {
  final EventFormController controller;

  const RecurrenceSettings({super.key, required this.controller});

  List<int> get _intervals =>
      controller.monthly ? const [1, 2, 3, 6] : const [1, 2, 3, 4];

  String _intervalLabel(int value) {
    final unit = controller.monthly ? 'Month' : 'Week';
    return value == 1 ? '1 $unit' : '$value ${unit}s';
  }

  Future<void> _pickRepeatsOn(BuildContext context) async {
    final date = controller.date;

    if (!controller.monthly) {
      final picked = await showOptionSheet<int>(
        context,
        title: 'Repeats on',
        options: const [1, 2, 3, 4, 5, 6, 7],
        selected: date.weekday,
        labelOf: weekdayName,
      );
      if (picked != null) controller.shiftToWeekday(picked);
      return;
    }

    final nth = ((date.day - 1) ~/ 7) + 1;
    final picked = await showOptionSheet<bool>(
      context,
      title: 'Repeats on',
      options: const [false, true],
      selected: controller.monthlyByWeekday,
      labelOf: (byWeekday) => byWeekday
          ? '${ordinal(nth)} ${weekdayName(date.weekday)}'
          : 'Day ${date.day}',
    );
    if (picked != null) {
      controller.update(() => controller.monthlyByWeekday = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = controller.date;
    final nth = ((date.day - 1) ~/ 7) + 1;

    final repeatsOn = controller.monthly
        ? (controller.monthlyByWeekday
            ? '${ordinal(nth)} ${weekdayName(date.weekday)}'
            : 'Day ${date.day}')
        : weekdayName(date.weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedToggle<bool>(
          options: const [false, true],
          selected: controller.monthly,
          labelOf: (monthly) => monthly ? 'Monthly' : 'Weekly',
          onChanged: controller.setMonthly,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EventFieldLabel('Repeats on'),
                  const SizedBox(height: 8),
                  EventPickerField(
                    value: repeatsOn,
                    onTap: () => _pickRepeatsOn(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EventFieldLabel('Every'),
                  const SizedBox(height: 8),
                  EventPickerField(
                    value: _intervalLabel(controller.interval),
                    onTap: () async {
                      final picked = await showOptionSheet<int>(
                        context,
                        title: 'Every',
                        options: _intervals,
                        selected: controller.interval,
                        labelOf: _intervalLabel,
                      );
                      if (picked != null) {
                        controller.update(() => controller.interval = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
