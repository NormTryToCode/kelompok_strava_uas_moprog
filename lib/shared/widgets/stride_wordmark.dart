import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class StrideWordmark extends StatelessWidget {
  const StrideWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            AppBrand.logoAsset,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Styles.canvas,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          AppBrand.wordmark,
          style: TextStyle(
            color: Styles.primaryLight,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }
}