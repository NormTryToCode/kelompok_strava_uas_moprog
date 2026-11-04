import 'package:flutter/material.dart';
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
  int _runSessions = 1; 
  int _weightKg = 65;
  String _sportCategory = "Berlari";
  bool _sharedBanner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_activeScreen == 0)
            ? "Profil Atlet - Anda"
            : (_activeScreen == 1)
              ? "Edit Profil"
              : (_activeScreen == 2)
                ? "Tempat Trofi"
                : "Bagikan Umpan Balik",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          if (_activeScreen != 0)
            IconButton.filled(
              onPressed: () {
                setState(() {
                  _activeScreen = 0;
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
        ],
      ),
      body: SafeArea(
        child: (_activeScreen == 1)
          ? EditProfileView(
            sportCategory: _sportCategory,
            weightKg: _weightKg,
            onToggleSport: () {
              setState(() {
                _sportCategory = 
                  (_sportCategory == "Berlari") ? "Bersepeda" : "Berlari";
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
            onSaveProfile: () {
              setState(() {
                _activeScreen = 0;
              });
            },
          )
          : (_activeScreen == 2)
            ? const TrophyCaseView()
            : (_activeScreen == 3)
              ? FeedbackView(
                onSubmitFeedback: () {
                  setState(() {
                    _activeScreen = 0;
                  });
                },
              )
          : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileHeaderWidget(
                  fullName: "Michael Respati Sanjaya Ho",
                  sportCategory: _sportCategory,
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
                  const Text(
                    "Tautan profil Michael berhasil disalin!",
                    style: TextStyle(color: Colors.green),
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
    );
  }
}