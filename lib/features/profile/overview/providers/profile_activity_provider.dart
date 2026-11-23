import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../statistics/providers/sport_statistics_provider.dart';

enum ProfileSubScreen {
  overview,
  editProfile,
  trophyCase,
  feedback,
  followersFollowing,
  gearManagement,
  segments,
  statistics,
}

@immutable
class ProfileNavigationState {
  final ProfileSubScreen activeScreen;
  final int activeTab;
  final int followInitialTab;

  const ProfileNavigationState({
    this.activeScreen = ProfileSubScreen.overview,
    this.activeTab = 0,
    this.followInitialTab = 0,
  });

  ProfileNavigationState copyWith({
    ProfileSubScreen? activeScreen,
    int? activeTab,
    int? followInitialTab,
  }) {
    return ProfileNavigationState(
      activeScreen: activeScreen ?? this.activeScreen,
      activeTab: activeTab ?? this.activeTab,
      followInitialTab: followInitialTab ?? this.followInitialTab,
    );
  }
}

final profileNavigationProvider =
    NotifierProvider<ProfileNavigationNotifier, ProfileNavigationState>(
  ProfileNavigationNotifier.new,
);

class ProfileNavigationNotifier extends Notifier<ProfileNavigationState> {
  @override
  ProfileNavigationState build() => const ProfileNavigationState();

  void selectTab(int tabIndex) {
    state = state.copyWith(activeTab: tabIndex);
  }

  void openScreen(ProfileSubScreen screen) {
    state = state.copyWith(activeScreen: screen);
  }

  void openFollowersFollowing({required int initialTab}) {
    state = state.copyWith(
      activeScreen: ProfileSubScreen.followersFollowing,
      followInitialTab: initialTab,
    );
  }

  void backToOverview() {
    state = state.copyWith(activeScreen: ProfileSubScreen.overview);
  }
}

final runSessionsProvider = Provider<int>((ref) {
  return ref.watch(sportStatisticsProvider).runSessions;
});