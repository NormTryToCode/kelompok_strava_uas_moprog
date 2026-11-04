import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton.filled(
                    onPressed: onSaveProfile,
                    icon: const Icon(Icons.arrow_back, color: Styles.tabActive),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(fontSize: 20, color: Styles.tabActive),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onSaveProfile,
                child: const Text(
                  "SELESAI",
                  style: TextStyle(color: Styles.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: Image(
                image: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 170,
                color: Styles.surface,
                padding: const EdgeInsets.all(10.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama depan",
                      style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Michael",
                      style: TextStyle(fontSize: 15, color: Styles.tabActive),
                    ),
                  ],
                ),
              ),
              Container(
                width: 170,
                color: Styles.surface,
                padding: const EdgeInsets.all(10.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama belakang",
                      style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Respati Sanjaya Ho",
                      style: TextStyle(fontSize: 15, color: Styles.tabActive),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Olahraga Utama",
                      style: TextStyle(fontSize: 11, color: Styles.tabInactive),
                    ),
                    Text(
                      sportCategory,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onToggleSport,
                  child: const Text("Ubah"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "INFORMASI ATLET",
            style: TextStyle(fontSize: 13, color: Styles.tabActive),
          ),
          const Text(
            "Digunakan untuk menghitung kalori, kekuatan, dan lainnya",
            style: TextStyle(fontSize: 12, color: Styles.tabInactive),
          ),
          const SizedBox(height: 8),
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(10.0),
            child: const Row(
              children: [
                Icon(Icons.favorite_border, color: Styles.accent),
                SizedBox(width: 10),
                Text(
                  "Perbarui profil otomatis dengan Google Fit",
                  style: TextStyle(fontSize: 13, color: Styles.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(10.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tanggal Lahir: 30/08/2007",
                  style: TextStyle(fontSize: 14, color: Styles.tabActive),
                ),
                Text(
                  "Jenis Kelamin: Pria",
                  style: TextStyle(fontSize: 14, color: Styles.tabActive),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Styles.surface,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Berat (kg): $weightKg kg",
                  style: const TextStyle(fontSize: 15, color: Styles.tabActive),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: onDecreaseWeight,
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: onIncreaseWeight,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}