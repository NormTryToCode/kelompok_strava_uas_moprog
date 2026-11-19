import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var step = 1; step <= totalSteps; step++) ...[
          _Node(step: step, currentStep: currentStep),
          if (step != totalSteps)
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: step < currentStep ? Palette.teal : Styles.inactive,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _Node extends StatelessWidget {
  final int step;
  final int currentStep;

  const _Node({required this.step, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final done = step < currentStep;
    final current = step == currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? Palette.teal
            : (current ? Palette.selectedFill : Colors.transparent),
        border: Border.all(
          color: done || current ? Palette.teal : Styles.inactive,
          width: 2,
        ),
      ),
      child: done
          ? const Icon(Icons.check, size: 16, color: Styles.background)
          : Text(
              '$step',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: current ? Palette.teal : Styles.tabInactive,
              ),
            ),
    );
  }
}
