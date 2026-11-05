import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubPhotoPicker extends StatelessWidget {
  final VoidCallback onTap;

  const ClubPhotoPicker({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 148,
        height: 148,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Styles.inactive,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 36, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Add photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -6,
              bottom: -6,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Styles.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.inactive, width: 1.5),
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
