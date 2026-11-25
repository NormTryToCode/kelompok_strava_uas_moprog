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
              'Edit Foto Profil',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: Styles.surfaceElevated,
              borderRadius: BorderRadius.circular(Radii.chip),
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.chip),
                onTap: () {
                  Navigator.pop(context);
                  onTakePhoto();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    border: Border.all(color: Styles.borderStrong),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Styles.primaryLight,
                        size: 21,
                      ),
                      SizedBox(width: 14),
                      Text(
                        'Ambil Foto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: Styles.surfaceElevated,
              borderRadius: BorderRadius.circular(Radii.chip),
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.chip),
                onTap: () {
                  Navigator.pop(context);
                  onPickFromGallery();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    border: Border.all(color: Styles.borderStrong),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Styles.primaryLight,
                        size: 21,
                      ),
                      SizedBox(width: 14),
                      Text(
                        'Pilih Dari Galeri',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}