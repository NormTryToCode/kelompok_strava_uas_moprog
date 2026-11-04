import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String sportCategory;
  final int activityCount;
  final int weightKg;
  final VoidCallback onEditProfile;
  final VoidCallback onShareProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.sportCategory,
    required this.activityCount,
    required this.weightKg,
    required this.onEditProfile,
    required this.onShareProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 64,
                height: 64,
                child: Image(
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "$activityCount aktivitas • $sportCategory ($weightKg kg)",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Text(
                    "0 pengikut  •  0 mengikuti",
                    style: TextStyle(fontSize: 13, color: Colors.deepOrange),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onEditProfile,
                child: const Text("Edit profil"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onShareProfile,
                child: const Text("Bagikan profil"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}