import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
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

  String _formatSportLabel(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'berlari':
      case 'running':
        return 'RUNNING';
      case 'bersepeda':
      case 'cycling':
        return 'CYCLING';
      case 'berenang':
      case 'swimming':
        return 'SWIMMING';
      default:
        return raw.trim().isEmpty ? 'ATHLETE' : raw.trim().toUpperCase();
    }
  }

  String _formatGenderLabel(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'pria':
        return 'Male';
      case 'wanita':
        return 'Female';
      case 'non-biner':
        return 'Non-binary';
      case 'memilih tidak mengatakan':
        return 'Private';
      default:
        return raw.trim().isEmpty ? 'Athlete' : raw.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String sportTag = _formatSportLabel(profileData.primarySport);
    final String genderTag = _formatGenderLabel(profileData.gender);
    final String locationLine =
      '${profileData.city.trim().isEmpty ? 'Jakarta' : profileData.city.trim()}, ${profileData.country.trim().isEmpty ? 'ID' : profileData.country.trim()}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Container(
        decoration: Styles.cardDecoration(
          radius: Radii.card,
          highlighted: true,
          withGlow: true,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -50,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  gradient: Styles.radialGlow(
                    color: Styles.primary,
                    intensity: 0.32,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Styles.canvas.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Styles.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.bolt_rounded,
                                size: 13,
                                color: Styles.primaryLight,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${AppBrand.wordmark} PASS  •  $sportTag',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Styles.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onEditProfile,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Styles.canvas.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Styles.borderStrong),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Styles.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onTapAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: Styles.primaryGradient,
                            boxShadow: Styles.glow(intensity: 0.35, blur: 16),
                          ),
                          child: AthleteAvatarWidget(
                            avatarPath: profileData.avatarPath,
                            size: 70,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: Styles.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Styles.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '$locationLine  •  $genderTag (${profileData.weightKg} kg)',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Styles.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (profileData.bio.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      profileData.bio,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Styles.canvas.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(Radii.field),
                      border: Border.all(color: Styles.border),
                    ),
                    child: Row(
                      children: [
                        _PassportMetric(
                          value: '$activityCount',
                          label: 'Sessions',
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: Styles.borderStrong,
                        ),
                        _PassportMetric(
                          value: '0',
                          label: 'Followers',
                          onTap: onTapFollowers,
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: Styles.borderStrong,
                        ),
                        _PassportMetric(
                          value: '$followingCount',
                          label: 'Following',
                          onTap: onTapFollowing,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
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
                            icon: const Icon(Icons.badge_outlined, size: 17),
                            label: const Text(
                              'Edit Pass',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Styles.canvas,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                  BorderRadius.circular(Radii.button),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onShareProfile,
                          icon: const Icon(Icons.ios_share_rounded, size: 17),
                          label: const Text(
                            'Share Card',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                              Styles.canvas.withValues(alpha: 0.55),
                            foregroundColor: Styles.textPrimary,
                            side: const BorderSide(color: Styles.borderStrong),
                            padding: const EdgeInsets.symmetric(vertical: 11),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _PassportMetric extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _PassportMetric({
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Styles.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}