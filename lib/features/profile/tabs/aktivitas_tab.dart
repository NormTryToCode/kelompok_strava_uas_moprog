import 'package:flutter/material.dart';

class AktivitasTab extends StatelessWidget {
  final int activityCount;
  final VoidCallback onAddFirstActivity;

  const AktivitasTab({
    super.key,
    required this.activityCount,
    required this.onAddFirstActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (activityCount == 0)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timeline,
                color: Colors.deepOrange,
              ),
              const SizedBox(height: 8),
              const Text(
                "Rekam Aktivitas Pertama Anda",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              const Text(
                "Saat Merekam Aktivitas, Anda Akan Melihatnya Di sini.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onAddFirstActivity, 
                child: const Text("Simulasi Rekam Lari (+1)"),
              ),
            ],
          ),
          if (activityCount > 0)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_run,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              Text(
                "Total $activityCount Aktivitas Lari Tercatat!",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                "Estimasi Total Jarak: ${activityCount * 3} km",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.deepOrange,
                )
              )
            ],
          )
        ],
      ),
    );
  }
}