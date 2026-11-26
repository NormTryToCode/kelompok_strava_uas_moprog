import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfilePhotoDialog extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onPickFromGallery;

  const ProfilePhotoDialog({
    super.key,
    required this.onTakePhoto,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Styles.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: const BorderSide(color: Styles.borderStrong, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Passport Photo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose how you want to capture your athlete portrait.',
              style: TextStyle(
                fontSize: 13,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _PhotoActionTile(
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              subtitle: 'Capture a fresh portrait with camera',
              onTap: () {
                Navigator.pop(context);
                onTakePhoto();
              },
            ),
            const SizedBox(height: 10),
            _PhotoActionTile(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              subtitle: 'Import an existing photo from device',
              onTap: () {
                Navigator.pop(context);
                onPickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PhotoActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.surfaceElevated,
      borderRadius: BorderRadius.circular(Radii.field),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.field),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 13.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.field),
            border: Border.all(color: Styles.borderStrong),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Styles.surfaceHighlight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: Styles.primaryLight, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}