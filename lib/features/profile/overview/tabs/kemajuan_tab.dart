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

  Widget _buildChip(int index, String label) {
    final bool isSelected = _subSection == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _subSection = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isSelected ? Styles.primaryGradient : null,
            color: isSelected ? null : Styles.surfaceElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Styles.primaryLight : Styles.borderStrong,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Styles.canvas : Styles.textPrimary,
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
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
          child: Row(
            children: [
              _buildChip(0, 'Berlari'),
              const SizedBox(width: 8),
              _buildChip(1, 'Usaha & Target'),
              const SizedBox(width: 8),
              _buildChip(2, 'Catatan'),
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