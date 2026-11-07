import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  static const _active = Color(0xFF8CD45B);
  static const _inactive = Color(0xFF2A3442);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= totalSteps; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: i <= currentStep ? _active : _inactive,
              ),
            ),
          ),
          if (i != totalSteps) const SizedBox(width: 4),
        ],
      ],
    );
  }
}
