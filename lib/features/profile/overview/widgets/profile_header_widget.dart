import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

import '../../edit_profile/models/athlete_profile_data.dart';
import '../../shared/widgets/athlete_avatar_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final AthleteProfileData profileData;
  final int activityCount;
  final int followingCount;
  final VoidCallback onTapAvatar;
  final VoidCallback onEditProfile;
  final VoidCallback onShareProfile;
  final VoidCallback onTapFollowers;
  final VoidCallback onTapFollowing;

  const ProfileHeaderWidget({
    super.key,
    required this.profileData,
    required this.activityCount,
    this.followingCount = 0,
    required this.onTapAvatar,
    required this.onEditProfile,
    required this.onShareProfile,
    required this.onTapFollowers,
    required this.onTapFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${profileData.city}, ${profileData.country}  •  ${profileData.primarySport.toUpperCase()}",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Styles.accent,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTapAvatar,
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
                        color: Styles.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$activityCount aktivitas  •  ${profileData.gender} (${profileData.weightKg} kg)",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Styles.surfaceHighlight,
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
                  color: Styles.primaryLight,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: onTapFollowers,
                child: const Text(
                  "0 pengikut",
                  style: TextStyle(fontSize: 14, color: Styles.primaryLight),
                ),
              ),
              const Text(
                "  •  ",
                style: TextStyle(fontSize: 14, color: Styles.primaryLight),
              ),
              GestureDetector(
                onTap: onTapFollowing,
                child: Text(
                  "$followingCount mengikuti",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Styles.primaryLight,
                  ),
                ),
              ),
            ],
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
                    style: TextStyle(color: Styles.canvas),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: ElevatedButton(
                  onPressed: onShareProfile,
                  child: const Text(
                    "Bagikan profil",
                    style: TextStyle(color: Styles.canvas),
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

