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
              GestureDetector(
                onTap: onTapKemajuan,
                child: Column(
                  children: [
                    Icon(
                      Icons.assessment,
                      color: (activeTab == 0)
                          ? Styles.accent
                          : Styles.tabInactive,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kemajuan",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: (activeTab == 0)
                            ? FontWeight.bold
                            : FontWeight.w500,
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
              ),
              GestureDetector(
                onTap: onTapAktivitas,
                child: Column(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: (activeTab == 1)
                          ? Styles.accent
                          : Styles.tabInactive,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Aktivitas",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: (activeTab == 1)
                            ? FontWeight.bold
                            : FontWeight.w500,
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
              ),
              GestureDetector(
                onTap: onTapLainnya,
                child: Column(
                  children: [
                    Icon(
                      Icons.menu,
                      color: (activeTab == 2)
                          ? Styles.accent
                          : Styles.tabInactive,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lainnya",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: (activeTab == 2)
                            ? FontWeight.bold
                            : FontWeight.w500,
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