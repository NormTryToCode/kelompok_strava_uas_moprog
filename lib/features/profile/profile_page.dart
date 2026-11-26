import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/providers/follow_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/add_action_router.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/add_menu_button.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';
import 'edit_profile/models/athlete_profile_data.dart';
import 'edit_profile/providers/athlete_profile_provider.dart';
import 'edit_profile/screens/edit_profile_screen.dart';
import 'gear/screens/gear_management_screen.dart';
import 'overview/providers/profile_activity_provider.dart';
import 'overview/tabs/aktivitas_tab.dart';
import 'overview/tabs/kemajuan_tab.dart';
import 'overview/tabs/lainnya_tab.dart';
import 'overview/widgets/profile_avatar_preview_dialog.dart';
import 'overview/widgets/profile_header_widget.dart';
import 'overview/widgets/profile_tab_bar.dart';
import 'shared/services/profile_share_service.dart';
import 'shared/utils/profile_page_route.dart';
import 'shared/utils/profile_snackbar_helper.dart';
import 'social_feedback/screens/feedback_screen.dart';
import 'social_feedback/screens/followers_following_screen.dart';
import 'social_feedback/screens/segment_location_screen.dart';
import 'statistics/providers/sport_statistics_provider.dart';
import 'statistics/screens/statistics_screen.dart';
import 'trophies/screens/trophy_case_screen.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _openAvatarPreviewDialog(
    BuildContext context,
    AthleteProfileData profileData,
  ) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return Theme(
          data: buildProfileDarkTheme(),
          child: ProfileAvatarPreviewDialog(profileData: profileData),
        );
      },
    );
  }

  Future<void> _handleShareProfile(
    BuildContext context,
    String fullName,
  ) async {
    final String status =
      await ProfileShareHelper.shareAthleteProfile(fullName);
    if (!context.mounted) return;
    ProfileSnackbarHelper.showSuccess(context, status);
  }

  Widget _buildActiveScreenContent(BuildContext context, WidgetRef ref) {
    final ProfileNavigationState navState =
      ref.watch(profileNavigationProvider);
    final navNotifier = ref.read(profileNavigationProvider.notifier);

    switch (navState.activeScreen) {
      case ProfileSubScreen.editProfile:
        return EditProfileView(onDone: navNotifier.backToOverview);
      case ProfileSubScreen.trophyCase:
        return TrophyCaseView(onBack: navNotifier.backToOverview);
      case ProfileSubScreen.feedback:
        return FeedbackView(onSubmitFeedback: navNotifier.backToOverview);
      case ProfileSubScreen.followersFollowing:
        return FollowersFollowingView(
          initialTabIndex: navState.followInitialTab,
          onBack: navNotifier.backToOverview,
        );
      case ProfileSubScreen.gearManagement:
        return GearManagementView(onBack: navNotifier.backToOverview);
      case ProfileSubScreen.segments:
        return SegmentLocationView(onBack: navNotifier.backToOverview);
      case ProfileSubScreen.statistics:
        return StatisticsView(onBack: navNotifier.backToOverview);
      case ProfileSubScreen.overview:
        break;
    }

    final AthleteProfileData profileData = ref.watch(athleteProfileProvider);
    final int runSessions = ref.watch(runSessionsProvider);
    final int followingCount = ref.watch(followingCountProvider);
    final statsNotifier = ref.read(sportStatisticsProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderWidget(
            profileData: profileData,
            activityCount: runSessions,
            followingCount: followingCount,
            onTapAvatar: () => _openAvatarPreviewDialog(context, profileData),
            onEditProfile: () =>
              navNotifier.openScreen(ProfileSubScreen.editProfile),
            onShareProfile: () =>
              _handleShareProfile(context, profileData.fullName),
            onTapFollowers: () =>
              navNotifier.openFollowersFollowing(initialTab: 1),
            onTapFollowing: () =>
              navNotifier.openFollowersFollowing(initialTab: 0),
          ),
          ProfileTabBar(
            activeTab: navState.activeTab,
            onTapKemajuan: () => navNotifier.selectTab(0),
            onTapAktivitas: () => navNotifier.selectTab(1),
            onTapLainnya: () => navNotifier.selectTab(2),
          ),
          IndexedStack(
            index: navState.activeTab,
            children: [
              KemajuanTab(
                runSessions: runSessions,
                onDecrement: () => statsNotifier.decrementRun(),
                onReset: () => statsNotifier.resetRun(),
                onIncrement: (runSessions < 10)
                  ? () => statsNotifier.incrementRun(maxLimit: 10)
                  : null,
                onOpenFeedback: () =>
                  navNotifier.openScreen(ProfileSubScreen.feedback),
              ),
              AktivitasTab(
                activityCount: runSessions,
                onAddFirstActivity: () => statsNotifier.incrementRun(),
              ),
              LainnyaTab(
                onOpenTrophyCase: () =>
                  navNotifier.openScreen(ProfileSubScreen.trophyCase),
                onOpenGearCatalog: () =>
                  navNotifier.openScreen(ProfileSubScreen.gearManagement),
                onOpenSegments: () =>
                  navNotifier.openScreen(ProfileSubScreen.segments),
                onOpenStatistics: () =>
                  navNotifier.openScreen(ProfileSubScreen.statistics),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(profileNavigationProvider);
    return Theme(
      data: buildProfileDarkTheme(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Styles.canvas,
          appBar: navState.activeScreen == ProfileSubScreen.overview
              ? AppHeader(
                  title: 'You',
                  actions: [
                    AddMenuButton(
                      onSelected: (action) => openAddAction(context, action),
                    ),
                    HeaderIconButton(
                      icon: Icons.search,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SearchPage(),
                        ),
                      ),
                    ),
                    HeaderIconButton(
                      icon: Icons.settings_outlined,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsPage(),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: SafeArea(
            child: _buildActiveScreenContent(context, ref),
          ),
        ),
      ),
    );
  }
}