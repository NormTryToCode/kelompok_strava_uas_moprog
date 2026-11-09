import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/athlete_profile_data.dart';
import 'athlete_avatar_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final AthleteProfileData profileData;
  final int activityCount;
  final VoidCallback onEditProfile;
  final VoidCallback onShareProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.profileData,
    required this.activityCount,
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
                "${profileData.city}, ${profileData.country}  •  ${profileData.primarySport.toUpperCase()}",
                style: const TextStyle(
                  fontSize: 11,
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
                  GestureDetector(
                    onTap: onEditProfile,
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Styles.tabActive,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onEditProfile,
                child: AthleteAvatarWidget(
                  avatarPath: profileData.avatarPath,
                  size: 68,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileData.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$activityCount aktivitas  •  ${profileData.gender} (${profileData.weightKg} kg)",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Styles.tabInactive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (profileData.bio.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                profileData.bio,
                style: const TextStyle(
                  fontSize: 15,
                  color: Styles.tabActive,
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
          const SizedBox(height: 14),
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