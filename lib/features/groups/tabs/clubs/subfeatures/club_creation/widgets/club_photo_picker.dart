import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ClubPhotoPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ClubPhotoPicker({
    super.key,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 124,
        height: 124,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.surface,
                border: Border.all(
                  color: hasImage ? Styles.primary : Styles.cardBorder,
                  width: 1.5,
                ),
                boxShadow: hasImage
                    ? Styles.glow(intensity: 0.25, blur: 16)
                    : null,
              ),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              child: hasImage
                  ? Image.file(
                      File(imagePath!),
                      width: 124,
                      height: 124,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _Placeholder(),
                    )
                  : const _Placeholder(),
            ),
            Positioned(
              right: 0,
              bottom: 4,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Styles.primaryGradient,
                  border: Border.all(color: Styles.canvas, width: 3),
                ),
                child: Icon(
                  hasImage ? Icons.edit_outlined : Icons.add,
                  size: 18,
                  color: Styles.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 30,
          color: Styles.teal,
        ),
        SizedBox(height: 6),
        Text(
          'Add photo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Styles.textPrimary,
          ),
        ),
      ],
    );
  }
}