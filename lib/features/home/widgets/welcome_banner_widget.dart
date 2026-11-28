import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/edit_profile/models/athlete_profile_data.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/edit_profile/providers/athlete_profile_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/shared/widgets/athlete_avatar_widget.dart';
import 'package:kelompok_strava_uas_moprog/features/home/data/welcome_quotes_data.dart';


class WelcomeBannerWidget extends ConsumerWidget {
  const WelcomeBannerWidget({super.key});

  String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _resolveDisplayName(AthleteProfileData profile, User? user) {
    final profileName = profile.firstName.trim();
    if (profileName.isNotEmpty && profileName != 'Stride Athlete') {
      return profileName;
    }
    final authName = user?.displayName?.trim();
    if (authName != null && authName.isNotEmpty) {
      return authName;
    }
    final email = user?.email?.trim();
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return profileName.isNotEmpty ? profileName : 'Runner';
  }

  String _resolveAvatarPath(AthleteProfileData profile, User? user) {
    final profileAvatar = profile.avatarPath.trim();
    if (profileAvatar.isNotEmpty) {
      return profileAvatar;
    }
    return user?.photoURL?.trim() ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final userName = _resolveDisplayName(profile, authUser);
    final avatarPath = _resolveAvatarPath(profile, authUser);

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
            avatarPath: avatarPath,
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
                "${userName}, ${getRandomQuote()}",
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
