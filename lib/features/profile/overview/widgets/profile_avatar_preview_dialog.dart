import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../../edit_profile/models/athlete_profile_data.dart';
import '../../shared/services/profile_share_service.dart';
import '../../shared/services/profile_url_service.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../../shared/widgets/custom_image_network.dart';

class ProfileAvatarPreviewDialog extends StatelessWidget {
  final AthleteProfileData profileData;

  const ProfileAvatarPreviewDialog({
    super.key,
    required this.profileData,
  });

  static const String _defaultAvatarUrl =
    'https://cdn-icons-png.flaticon.com/512/4140/4140048.png';

  @override
  Widget build(BuildContext context) {
    final bool hasLocalFile = profileData.avatarPath.isNotEmpty &&
      File(profileData.avatarPath).existsSync();
    final String displayFirstName = profileData.firstName.trim().isNotEmpty
      ? profileData.firstName.trim()
      : 'Atlet';
    final ProfileUrlService urlService = ProfileUrlService();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              color: Styles.surface,
              borderRadius: BorderRadius.circular(Radii.card),
              border: Border.all(
                color: Styles.borderStrong,
                width: 2.0,
              ),
              boxShadow: Styles.ambientGlow(),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.card - 2),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  hasLocalFile
                    ? Image.file(
                        File(profileData.avatarPath),
                        fit: BoxFit.cover,
                      )
                    : const CustomImageNetwork(
                        imageUrl: _defaultAvatarUrl,
                        fit: BoxFit.cover,
                      ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(225, 7, 6, 12),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayFirstName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${profileData.city}, ${profileData.country} • ${profileData.primarySport}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.surfaceElevated,
                  foregroundColor: Styles.textPrimary,
                  side: const BorderSide(color: Styles.borderStrong),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 11.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.button),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primary,
                  foregroundColor: Styles.textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 11.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.button),
                  ),
                ),
                onPressed: () async {
                  final String url = ProfileShareHelper.buildProfileUrl(
                    profileData.fullName,
                  );
                  try {
                    await urlService.openUrl(url);
                  } catch (e) {
                    if (!context.mounted) return;
                    ProfileSnackbarHelper.showError(context, '$e');
                  }
                },
                icon: const Icon(Icons.link_rounded, size: 18),
                label: const Text(
                  'Buka Web',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}