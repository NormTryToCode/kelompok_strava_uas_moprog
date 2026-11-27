import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/groups_page.dart';
import 'package:kelompok_strava_uas_moprog/features/home/home_page.dart';
import 'package:kelompok_strava_uas_moprog/features/map/map_page.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/profile_page.dart';
import 'package:kelompok_strava_uas_moprog/features/record/record_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_footer.dart';
import 'package:kelompok_strava_uas_moprog/shell/user_data_hydrator.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    MapPage(),
    Record(),
    GroupsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      unawaited(ref.read(userDataHydratorProvider)());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      body: SafeArea(
        child: IndexedStack(index: _index, children: _pages),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}