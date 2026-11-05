import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _weightKg = 61;
  String _sportCategory = "Berlari";
  String _athleteBio = "";
  bool _sharedBanner = false;

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _loadSavedProfileBio();
  }

  void _loadSavedProfileBio() async {
    String savedBio = await _asyncPrefs.getString('text') ?? '';
    setState(() {
      _athleteBio = savedBio;
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
                    sportCategory: _sportCategory,
                    weightKg: _weightKg,
                    initialBio: _athleteBio,
                    onToggleSport: () {
                      setState(() {
                        _sportCategory = (_sportCategory == "Berlari")
                            ? "Bersepeda"
                            : "Berlari";
                      });
                    },
                    onDecreaseWeight: () {
                      setState(() {
                        if (_weightKg > 30) {
                          _weightKg--;
                        }
                      });
                    },
                    onIncreaseWeight: () {
                      setState(() {
                        _weightKg++;
                      });
                    },
                    onBioSaved: (String updatedBio) {
                      setState(() {
                        _athleteBio = updatedBio;
                      });
                    },
                    onSaveProfile: () {
                      setState(() {
                        _activeScreen = 0;
                      });
                    },
                  )
                : (_activeScreen == 2)
                  ? TrophyCaseView(
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
                        fullName: "Michael Respati Sanjaya Ho",
                        sportCategory: _sportCategory,
                        bioText: _athleteBio,
                        activityCount: _runSessions,
                        weightKg: _weightKg,
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Tautan profil Michael berhasil disalin!",
                            style: TextStyle(color: Styles.active),
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