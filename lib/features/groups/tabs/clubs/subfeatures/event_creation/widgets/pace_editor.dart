import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_input_decoration.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/segmented_toggle.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';

class PaceEditor extends StatelessWidget {
  final EventFormController controller;

  const PaceEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final unit = controller.paceUnit;
    final ranges = controller.paceRanges;
    final canAdd = ranges.length < EventFormController.maxPaceRanges;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedToggle<PaceUnit>(
          options: PaceUnit.values,
          selected: unit,
          labelOf: (u) => u == PaceUnit.mph ? 'Miles' : 'Kilometers',
          onChanged: controller.setPaceUnit,
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < ranges.length; i++) ...[
          _PaceRow(
            key: ValueKey('pace-${ranges[i].id}'),
            controller: controller,
            range: ranges[i],
            letter: String.fromCharCode(65 + i),
            unit: unit,
            canRemove: ranges.length > 1,
          ),
          const SizedBox(height: 12),
        ],
        GhostButton(
          label: canAdd ? 'Add pace group' : 'Maximum reached',
          icon: canAdd ? Icons.add : null,
          height: 50,
          onPressed: canAdd ? controller.addPaceRange : null,
        ),
      ],
    );
  }
}

class _PaceRow extends StatelessWidget {
  final EventFormController controller;
  final PaceRangeDraft range;
  final String letter;
  final PaceUnit unit;
  final bool canRemove;

  const _PaceRow({
    super.key,
    required this.controller,
    required this.range,
    required this.letter,
    required this.unit,
    required this.canRemove,
  });

  @override
  Widget build(BuildContext context) {
    final error = controller.showErrors ? range.error : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$letter:',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Styles.tabInactive,
                ),
              ),
            ),
            Expanded(child: _numberField(isMin: true)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            Expanded(child: _numberField(isMin: false)),
            const SizedBox(width: 10),
            SizedBox(
              width: 36,
              child: Text(
                unit.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 32,
              child: canRemove
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => controller.removePaceRange(range.id),
                      icon: const Icon(Icons.close, color: eventErrorColor),
                    )
                  : null,
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 28),
            child: Text(
              error,
              style: const TextStyle(fontSize: 13, color: eventErrorColor),
            ),
          ),
      ],
    );
  }

  Widget _numberField({required bool isMin}) {
    return TextFormField(
      key: ValueKey('pace-${range.id}-${isMin ? 'min' : 'max'}-${unit.name}'),
      initialValue: isMin ? range.min : range.max,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [decimalFormatter(integerDigits: 3, fractionDigits: 1)],
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      style: eventFieldTextStyle,
      decoration: eventInputDecoration().copyWith(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      ),
      onChanged: (value) => controller.update(() {
        if (isMin) {
          range.min = value;
        } else {
          range.max = value;
        }
      }),
    );
  }
}
