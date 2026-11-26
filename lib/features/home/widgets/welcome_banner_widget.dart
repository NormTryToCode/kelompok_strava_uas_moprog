import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/edit_profile/providers/athlete_profile_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/shared/widgets/athlete_avatar_widget.dart';

class WelcomeBannerWidget extends ConsumerWidget {
  const WelcomeBannerWidget({super.key});

  String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final rawName = profile.firstName.trim();
    final userName = rawName.isEmpty ? 'Runner' : rawName;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: Styles.primaryGradient,
            boxShadow: Styles.glow(intensity: 0.3, blur: 14),
          ),
          child: AthleteAvatarWidget(
            avatarPath: profile.avatarPath,
            size: 50,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _timeGreeting(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Styles.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Styles.surfaceHighlight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Styles.borderStrong),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt_rounded,
                size: 14,
                color: Styles.primaryLight,
              ),
              SizedBox(width: 4),
              Text(
                'READY',
                style: TextStyle(
                  color: Styles.primaryLight,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
