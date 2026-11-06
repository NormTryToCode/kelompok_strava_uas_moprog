import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'custom_image_network.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String sportCategory;
  final String bioText;
  final int activityCount;
  final int weightKg;
  final VoidCallback onEditProfile;
  final VoidCallback onShareProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.sportCategory,
    required this.bioText,
    required this.activityCount,
    required this.weightKg,
    required this.onEditProfile,
    required this.onShareProfile,
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
              Text(
                sportCategory.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Styles.accent,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.add, color: Styles.tabActive),
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Styles.tabActive),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.settings, color: Styles.tabActive),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 64,
                height: 64,
                child: CustomImageNetwork(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                  height: 64,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Styles.tabActive,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$activityCount aktivitas  •  $sportCategory ($weightKg kg)",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Styles.tabInactive,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (bioText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                bioText,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Styles.tabInactive,
                ),
              ),
            ),
          const SizedBox(height: 10),
          const Text(
            "0 pengikut  •  0 mengikuti",
            style: TextStyle(
              fontSize: 14,
              color: Styles.tabActive,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: onEditProfile,
                  child: const Text(
                    "Edit profil",
                    style: TextStyle(color: Styles.background),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: onShareProfile,
                  child: const Text(
                    "Bagikan profil",
                    style: TextStyle(color: Styles.background),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}