import 'package:flutter/material.dart';

class LainnyaTab extends StatefulWidget{
  final VoidCallback onOpenTrophyCase;

  const LainnyaTab({
    super.key,
    required this.onOpenTrophyCase,
  });

  @override
  State<LainnyaTab> createState() => _LainnyaTabState();
}

class _LainnyaTabState extends State<LainnyaTab> {
  bool joinedChallenge = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: Colors.deepOrange),
              SizedBox(width: 4),
              Text("Statistik   |   "),
              Icon(Icons.location_on, color: Colors.deepOrange),
              SizedBox(width: 4),
              Text("Segmen    |   "),
              Icon(Icons.pedal_bike, color: Colors.deepOrange),
              SizedBox(width: 4),
              Text("Perlengkapan"),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Tantangan",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            "Ikuti Tantangan Untuk Membangun Kebiasaan & Hadiah.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                joinedChallenge = !joinedChallenge;
              });
            }, 
            child: Text(
              joinedChallenge
                ? "Tantangan 5K Diikuti"
                : "Temukan Tantangan Baru",
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tempat Trofi (6 Tonggak)",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: widget.onOpenTrophyCase, 
                child: const Text("Semua Trofi"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}