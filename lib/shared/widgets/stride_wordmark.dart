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
        SizedBox(
          width: 28,
          height: 28,
          child: Image.asset('asset/images/Logo.png', width: 200, height: 200,),
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

