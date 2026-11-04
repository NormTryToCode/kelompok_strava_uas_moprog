import 'package:flutter/material.dart';

class ProfileTabBar extends StatelessWidget {
  final int activeTab;
  final VoidCallback onTapKemajuan;
  final VoidCallback onTapAktivitas;
  final VoidCallback onTapLainnya;

  const ProfileTabBar({
    super.key,
    required this.activeTab,
    required this.onTapKemajuan,
    required this.onTapAktivitas,
    required this.onTapLainnya,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onTapKemajuan, 
            child: Text(
              "Kemajuan",
              style: TextStyle(
                color: (activeTab == 0) ? Colors.deepOrange : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTapAktivitas, 
            child: Text(
              "Aktivitas",
              style: TextStyle(
                color: (activeTab == 1) ? Colors.deepOrange : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onTapLainnya,
            child: Text(
              "Lainnya",
              style: TextStyle(
                color: (activeTab == 2) ? Colors.deepOrange : Colors.black,
              ),
            ),
          ),
        ],
      )
    );
  }
}