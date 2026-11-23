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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.surfaceHighlight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Styles.primary.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    '${profileData.city}, ${profileData.country}  •  ${profileData.primarySport.toUpperCase()}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Styles.primaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onEditProfile,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Styles.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Styles.borderStrong),
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Styles.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTapAvatar,
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: Styles.primaryGradient,
                    boxShadow: Styles.glow(intensity: 0.3, blur: 14),
                  ),
                  child: AthleteAvatarWidget(
                    avatarPath: profileData.avatarPath,
                    size: 68,
                  ),
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
                        fontWeight: FontWeight.w800,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activityCount aktivitas  •  ${profileData.gender} (${profileData.weightKg} kg)',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Styles.textSecondary,
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
                  fontSize: 14.5,
                  color: Styles.textPrimary,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: onTapFollowers,
                child: const Text(
                  '0 pengikut',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Styles.secondary,
                  ),
                ),
              ),
              const Text(
                '  •  ',
                style: TextStyle(
                  fontSize: 14,
                  color: Styles.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: onTapFollowing,
                child: Text(
                  '$followingCount mengikuti',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Styles.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: Styles.buttonDecoration(
                    radius: Radii.button,
                    withGlow: true,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text(
                      'Edit profil',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Styles.canvas,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.button),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShareProfile,
                  icon: const Icon(Icons.share_outlined, size: 17),
                  label: const Text(
                    'Bagikan profil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.surfaceElevated,
                    foregroundColor: Styles.textPrimary,
                    side: const BorderSide(color: Styles.borderStrong),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.button),
                    ),
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