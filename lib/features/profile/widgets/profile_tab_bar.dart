import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class ProfileTabBar extends StatelessWidget {
  final int activeTab;
  final VoidCallback onTapKemajuan;
  final VoidCallback onTapAktivitas;
  final VoidCallback onTapLainnya;

  const ProfileTabBar({
    super.key,
    required this.activeTab,
    required this.onTapKemajuan,
    required this.onTapAktivitas,
    required this.onTapLainnya,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.background,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton.filled(
                    onPressed: onTapKemajuan,
                    icon: Icon(
                      Icons.assessment,
                      color: (activeTab == 0)
                        ? Styles.accent
                        : Styles.tabInactive,
                    ),
                  ),
                  Text(
                    "Kemajuan",
                    style: TextStyle(
                      fontSize: 13,
                      color: (activeTab == 0)
                        ? Styles.tabActive
                        : Styles.tabInactive,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 110,
                    height: 3,
                    color: (activeTab == 0)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton.filled(
                    onPressed: onTapAktivitas,
                    icon: Icon(
                      Icons.timeline,
                      color: (activeTab == 1)
                        ? Styles.accent
                        : Styles.tabInactive,
                    ),
                  ),
                  Text(
                    "Aktivitas",
                    style: TextStyle(
                      fontSize: 13,
                      color: (activeTab == 1)
                        ? Styles.tabActive
                        : Styles.tabInactive,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 110,
                    height: 3,
                    color: (activeTab == 1)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton.filled(
                    onPressed: onTapLainnya,
                    icon: Icon(
                      Icons.menu,
                      color: (activeTab == 2)
                        ? Styles.accent
                        : Styles.tabInactive,
                    ),
                  ),
                  Text(
                    "Lainnya",
                    style: TextStyle(
                      fontSize: 13,
                      color: (activeTab == 2)
                          ? Styles.tabActive
                          : Styles.tabInactive,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 110,
                    height: 3,
                    color: (activeTab == 2)
                      ? Styles.accent
                      : Styles.background,
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 1,
            color: Styles.inactive,
          ),
        ],
      ),
    );
  }
}