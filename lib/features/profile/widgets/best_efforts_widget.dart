import 'package:flutter/material.dart';

class BestEffortsWidget extends StatelessWidget {
  const BestEffortsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Usaha Terbaik & Relatif",
            style: TextStyle(fontSize: 16, color: Colors.deepOrange),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.military_tech, color: Colors.grey),
              SizedBox(width: 6),
              Text("5K Tercepat ke-2 (Nov 3, 2026): 30:12"),
            ],
          ),
          SizedBox(height: 6),
          Text(
            "Usaha Relatif: 89 (Nov 2-8) | 22 (Okt 26-Nov 1)",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            "Catatan Latihan: 10,9 km (Kam: 3,7 km • Sab: 6,4 km)",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}