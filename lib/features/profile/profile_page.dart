import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/athlete_profile_data.dart';
import 'tabs/aktivitas_tab.dart';
import 'tabs/kemajuan_tab.dart';
import 'tabs/lainnya_tab.dart';
import 'views/edit_profile_view.dart';
import 'views/feedback_view.dart';
import 'views/trophy_case_view.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/profile_tab_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _activeScreen = 0;
  int _activeTab = 0;
  int _runSessions = 0;
  bool _sharedBanner = false;

  AthleteProfileData _profileData = const AthleteProfileData(
    firstName: 'Michael',
    lastName: 'Respati Sanjaya Ho',
    city: 'Jakarta',
    country: 'INDONESIA',
    primarySport: 'Berlari',
    bio: 'I Like Run',
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
    final bool googleFit = await _asyncPrefs.getBool('switch') ?? false;

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
        googleFitConnected: googleFit,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Animate(
        effects: const [FadeEffect()],
        child: Scaffold(
          backgroundColor: Styles.background,
          body: SafeArea(
            child: (_activeScreen == 1)
                ? EditProfileView(
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
                  )
                : (_activeScreen == 2)
                    ? TrophyCaseView(
                        currentActivities: _runSessions,
                        onBack: () {
                          setState(() {
                            _activeScreen = 0;
                          });
                        },
                      )
                    : (_activeScreen == 3)
                        ? FeedbackView(
                            onSubmitFeedback: () {
                              setState(() {
                                _activeScreen = 0;
                              });
                            },
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileHeaderWidget(
                                  profileData: _profileData,
                                  activityCount: _runSessions,
                                  onEditProfile: () {
                                    setState(() {
                                      _activeScreen = 1;
                                    });
                                  },
                                  onShareProfile: () {
                                    setState(() {
                                      _sharedBanner = !_sharedBanner;
                                    });
                                  },
                                ),
                                if (_sharedBanner)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Tautan profil ${_profileData.fullName} berhasil disalin!",
                                      style: const TextStyle(
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
                                    onOpenTrophyCase: () {
                                      setState(() {
                                        _activeScreen = 2;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
          ),
        ),
      ),
    );
  }
}