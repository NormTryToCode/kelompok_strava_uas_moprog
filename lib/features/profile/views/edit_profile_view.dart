import 'package:flutter/material.dart';

class EditProfileView extends StatelessWidget {
  final String sportCategory;
  final int weightKg;
  final VoidCallback onToggleSport;
  final VoidCallback onDecreaseWeight;
  final VoidCallback onIncreaseWeight;
  final VoidCallback onSaveProfile;

  const EditProfileView({
    super.key,
    required this.sportCategory,
    required this.weightKg,
    required this.onToggleSport,
    required this.onDecreaseWeight,
    required this.onIncreaseWeight,
    required this.onSaveProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Edit Profile Atlet",
              style: TextStyle(fontSize: 22, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            const Text("Nama Depan : Michael"),
            const Text("Nama Belakang : Respati Sanjaya Ho"),
            const Text("Kota : Jakarta  |   Negara : Indonesia"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Olahraga Utama: $sportCategory"),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onToggleSport, 
                  child: const Text("Ganti Olahraga"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "INFORMASI ATLET",
              style: TextStyle(fontSize: 16, color: Colors.deepOrange),
            ),
            const Text("Tanggal Lahir: 30/08/2007   |   Jenis Kelamin: Pria"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onDecreaseWeight, 
                  icon: const Icon(Icons.remove)
                ),
                const SizedBox(width: 12),
                Text(
                  "Berat: $weightKg kg",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onIncreaseWeight, 
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onSaveProfile, 
              child: const Text("SELESAI & SIMPAN"),
            )
          ],
        ),
      ),
    );
  }
}