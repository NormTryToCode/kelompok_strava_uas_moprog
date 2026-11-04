import 'package:flutter/material.dart';
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
  bool showBestEfforts = false;

  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showBestEfforts = false;
                });
              }, 
              child: const Text("Target Minggu Ini"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showBestEfforts = true;
                });
              }, 
              child: const Text("Usaha Terbaik (5K)"),
            )
          ],
        ),
        if (!showBestEfforts)
          WeeklyRunCounter(
            runSessions: widget.runSessions, 
            onDecrement: widget.onDecrement, 
            onReset: widget.onReset, 
            onIncrement: widget.onIncrement,
          ),
        if (showBestEfforts) const BestEffortsWidget(),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tertarik Berbagi Masukan ?",
              style: TextStyle(fontSize: 13),
            ),
            ElevatedButton(
              onPressed: widget.onOpenFeedback, 
              child: const Text("Beri Masukan"),
            )
          ],
        )
      ],
    );
  }
}