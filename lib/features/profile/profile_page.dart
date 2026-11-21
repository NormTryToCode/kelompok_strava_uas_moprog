import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile/models/athlete_profile_data.dart';
import 'overview/tabs/aktivitas_tab.dart';
import 'overview/tabs/kemajuan_tab.dart';
import 'overview/tabs/lainnya_tab.dart';
import 'edit_profile/screens/edit_profile_screen.dart';
import 'social_feedback/screens/feedback_screen.dart';
import 'social_feedback/screens/followers_following_screen.dart';
import 'gear/screens/gear_management_screen.dart';
import 'social_feedback/screens/segment_location_screen.dart';
import 'statistics/screens/statistics_screen.dart';
import 'trophies/screens/trophy_case_screen.dart';
import 'overview/widgets/profile_avatar_preview_dialog.dart';
import 'overview/widgets/profile_header_widget.dart';
import 'overview/widgets/profile_tab_bar.dart';
import 'overview/widgets/share_profile_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _activeScreen = 0;
  int _activeTab = 0;
  int _followInitialTab = 0;
  int _runSessions = 0;
  Set<String> _claimedTrophyIds = {};
  String _shareStatusMessage = '';
  int _shareMessageToken = 0;

  AthleteProfileData _profileData = const AthleteProfileData(
    firstName: 'Michael',
    lastName: 'Respati Sanjaya Ho',
    city: 'Jakarta',
    country: 'INDONESIA',
    primarySport: 'Berlari',
    bio: 'I Like Runnn',
    birthDate: '30/08/2007',
    gender: 'Pria',
    weightKg: '74,0',
  );

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _loadSavedProfileData();
  }

  void _loadSavedProfileData() async {
    final String firstName =
      await _asyncPrefs.getString('first_name') ?? _profileData.firstName;
    final String lastName =
      await _asyncPrefs.getString('last_name') ?? _profileData.lastName;
    final String city =
      await _asyncPrefs.getString('city') ?? _profileData.city;
    final String country =
      await _asyncPrefs.getString('country') ?? _profileData.country;
    final String sport =
      await _asyncPrefs.getString('sport') ?? _profileData.primarySport;
    final String savedBio =
      await _asyncPrefs.getString('text') ?? _profileData.bio;
    final String birthDate =
      await _asyncPrefs.getString('birth_date') ?? _profileData.birthDate;
    final String gender =
      await _asyncPrefs.getString('gender') ?? _profileData.gender;
    final String weight =
      await _asyncPrefs.getString('weight_kg') ?? _profileData.weightKg;
    final String avatarPath =
      await _asyncPrefs.getString('avatar_path') ?? _profileData.avatarPath;
    final List<String> savedClaimed =
      await _asyncPrefs.getStringList('claimed_trophies') ?? [];

    if (!mounted) return;
    setState(() {
      _profileData = AthleteProfileData(
        firstName: firstName,
        lastName: lastName,
        city: city,
        country: country,
        primarySport: sport,
        bio: savedBio,
        birthDate: birthDate,
        gender: gender,
        weightKg: weight,
        avatarPath: avatarPath,
      );
      _claimedTrophyIds = savedClaimed.toSet();
    });
  }

  void _toggleClaimedTrophy(String badgeId) async {
    setState(() {
      if (_claimedTrophyIds.contains(badgeId)) {
        _claimedTrophyIds.remove(badgeId);
      } else {
        _claimedTrophyIds.add(badgeId);
      }
    });
    await _asyncPrefs.setStringList(
      'claimed_trophies',
      _claimedTrophyIds.toList(),
    );
  }

  void _openAvatarPreviewDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(200, 15, 20, 30),
      builder: (BuildContext context) {
        return ProfileAvatarPreviewDialog(profileData: _profileData);
      },
    );
  }

  void _showTemporaryShareMessage(String message) async {
    final int currentToken = ++_shareMessageToken;
    setState(() {
      _shareStatusMessage = message;
    });

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted || currentToken != _shareMessageToken) return;

    setState(() {
      _shareStatusMessage = '';
    });
  }

  void _handleShareProfile() async {
    final String status =
        await ProfileShareHelper.shareAthleteProfile(_profileData.fullName);
    if (!mounted) return;
    _showTemporaryShareMessage(status);
  }

  double get _parsedWeightKg {
    final normalized = _profileData.weightKg.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 74.0;
  }

  Widget _buildActiveScreenContent() {
    if (_activeScreen == 1) {
      return EditProfileView(
        initialData: _profileData,
        onCancel: () {
          setState(() {
            _activeScreen = 0;
          });
        },
        onSaveProfile: (AthleteProfileData updatedData) {
          setState(() {
            _profileData = updatedData;
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 2) {
      return TrophyCaseView(
        currentActivities: _runSessions,
        claimedTrophyIds: _claimedTrophyIds,
        onToggleClaim: _toggleClaimedTrophy,
        onBack: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 3) {
      return FeedbackView(
        onSubmitFeedback: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 4) {
      return FollowersFollowingView(
        initialTabIndex: _followInitialTab,
        onBack: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 5) {
      return GearManagementView(
        onBack: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 7) {
      return SegmentLocationView(
        onBack: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }
    if (_activeScreen == 8) {
      return StatisticsView(
        initialRunSessions: _runSessions,
        athleteWeightKg: _parsedWeightKg,
        onRunSessionsChanged: (int updatedRuns) {
          setState(() {
            _runSessions = updatedRuns;
          });
        },
        onBack: () {
          setState(() {
            _activeScreen = 0;
          });
        },
      );
    }

    return ListenableBuilder(
      listenable: FollowController.instance,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeaderWidget(
                profileData: _profileData,
                activityCount: _runSessions,
                followingCount: FollowController.instance.followingCount,
                onTapAvatar: _openAvatarPreviewDialog,
                onEditProfile: () {
                  setState(() {
                    _activeScreen = 1;
                  });
                },
                onShareProfile: _handleShareProfile,
                onTapFollowers: () {
                  setState(() {
                    _followInitialTab = 1;
                    _activeScreen = 4;
                  });
                },
                onTapFollowing: () {
                  setState(() {
                    _followInitialTab = 0;
                    _activeScreen = 4;
                  });
                },
              ),
              if (_shareStatusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    _shareStatusMessage,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Styles.active,
                    ),
                  ),
                ),
              ProfileTabBar(
                activeTab: _activeTab,
                onTapKemajuan: () {
                  setState(() {
                    _activeTab = 0;
                  });
                },
                onTapAktivitas: () {
                  setState(() {
                    _activeTab = 1;
                  });
                },
                onTapLainnya: () {
                  setState(() {
                    _activeTab = 2;
                  });
                },
              ),
              if (_activeTab == 0)
                KemajuanTab(
                  runSessions: _runSessions,
                  onDecrement: () {
                    setState(() {
                      if (_runSessions > 0) {
                        _runSessions--;
                      }
                    });
                  },
                  onReset: () {
                    setState(() {
                      _runSessions = 0;
                    });
                  },
                  onIncrement: (_runSessions < 10)
                    ? () {
                      setState(() {
                        _runSessions = _runSessions + 1;
                      });
                    }
                    : null,
                  onOpenFeedback: () {
                    setState(() {
                      _activeScreen = 3;
                    });
                  },
                ),
              if (_activeTab == 1)
                AktivitasTab(
                  activityCount: _runSessions,
                  onAddFirstActivity: () {
                    setState(() {
                      _runSessions++;
                    });
                  },
                ),
              if (_activeTab == 2)
                LainnyaTab(
                  currentActivities: _runSessions,
                  claimedTrophyIds: _claimedTrophyIds,
                  onOpenTrophyCase: () {
                    setState(() {
                      _activeScreen = 2;
                    });
                  },
                  onOpenGearCatalog: () {
                    setState(() {
                      _activeScreen = 5;
                    });
                  },
                  onOpenSegments: () {
                    setState(() {
                      _activeScreen = 7;
                    });
                  },
                  onOpenStatistics: () {
                    setState(() {
                      _activeScreen = 8;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Animate(
            effects: const [FadeEffect()],
            child: Scaffold(
              backgroundColor: Styles.background,
              body: SafeArea(
                child: _buildActiveScreenContent(),
              ),
            ),
          ),
        ),
      );
  }
}