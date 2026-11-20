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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _subSection = 0;
                  });
                },
                child: Text(
                  "Berlari",
                  style: TextStyle(
                    color: (_subSection == 0)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _subSection = 1;
                  });
                },
                child: Text(
                  "Usaha & Target",
                  style: TextStyle(
                    color: (_subSection == 1)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _subSection = 2;
                  });
                },
                child: Text(
                  "Catatan",
                  style: TextStyle(
                    color: (_subSection == 2)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ),
              ),
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