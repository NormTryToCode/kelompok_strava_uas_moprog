import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../widgets/best_efforts_widget.dart';
import '../widgets/weekly_run_counter.dart';

class KemajuanTab extends StatefulWidget {
  final int runSessions;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback? onIncrement;
  final VoidCallback onOpenFeedback;

  const KemajuanTab({
    super.key,
    required this.runSessions,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrement,
    required this.onOpenFeedback,
  });

  @override
  State<KemajuanTab> createState() => _KemajuanTabState();
}

class _KemajuanTabState extends State<KemajuanTab> {
  int _subSection = 0;

  Widget _buildModeChip(int index, String label) {
    final bool isSelected = _subSection == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _subSection = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
              ? Styles.surfaceHighlight
              : Styles.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Styles.primaryLight : Styles.border,
              width: isSelected ? 1.3 : 1.0,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Styles.primaryLight : Styles.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              _buildModeChip(0, 'Momentum'),
              const SizedBox(width: 8),
              _buildModeChip(1, 'Records'),
              const SizedBox(width: 8),
              _buildModeChip(2, 'Cadence'),
            ],
          ),
        ),
        if (_subSection == 0)
          WeeklyRunCounter(
            runSessions: widget.runSessions,
            onDecrement: widget.onDecrement,
            onReset: widget.onReset,
            onIncrement: widget.onIncrement,
          ),
        if (_subSection != 0)
          BestEffortsWidget(
            viewMode: _subSection,
            runSessions: widget.runSessions,
            onOpenFeedback: widget.onOpenFeedback,
          ),
      ],
    );
  }
}