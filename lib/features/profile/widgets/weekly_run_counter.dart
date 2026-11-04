import 'package:flutter/material.dart';

class WeeklyRunCounter extends StatelessWidget {
  final int runSessions;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback? onIncrement;

  const WeeklyRunCounter({
    super.key,
    required this.runSessions,
    required this.onDecrement,
    required this.onReset,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final int distanceKm = runSessions * 3;
    final int durationMinutes = runSessions * 25;
    final int elevationMeters = runSessions * 15;

    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Minggu ini (Berlari)",
            style: TextStyle(fontSize: 16, color: Colors.deepOrange),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Jarak : $distanceKm km"),
              const SizedBox(width: 12),
              Text("Waktu : ${durationMinutes}m"),
              const SizedBox(width: 12),
              Text("Elev: $elevationMeters m"),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Target Berlari Mingguan: $runSessions / 4 lari",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDecrement, 
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                onPressed: onReset, 
                icon: const Icon(Icons.exposure_zero),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                onPressed: onIncrement, 
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (runSessions >= 4 && runSessions < 10)
          const Text(
            "Target Mingguan 4 Lari Tercapai! Pertahankan!",
            style: TextStyle(color: Colors.green),
          ),
          if (runSessions >= 10)
          const Text(
            "Sesi Latihan Sudah Mencapai Batas Maksimal 10!",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}