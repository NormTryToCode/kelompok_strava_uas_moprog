import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/features/home/home_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/groups_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_footer.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/map/map_page.dart';
import 'package:kelompok_strava_uas_moprog/features/profile/profile_page.dart';
import "package:kelompok_strava_uas_moprog/features/record/record_page.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/user_repository.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) UserRepository.instance.ensureProfile(user);
  }

  static const _pages = [
    HomePage(),
    MapPage(),
    Record(),
    GroupsPage(),
    ProfilePage(),
  ];

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

class _Placeholder extends StatelessWidget {
  final String name;
  const _Placeholder(this.name);

  @override
  Widget build(BuildContext context) => Center(
    child: Text(name, style: const TextStyle(color: Colors.white)),
  );
}
