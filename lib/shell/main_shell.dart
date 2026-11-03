import 'package:flutter/material.dart';
import '../features/groups/groups_page.dart';
import '../shared/widgets/app_footer.dart';
import '../core/theme/styles.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [
    _Placeholder('Home'),
    _Placeholder('Maps'),
    _Placeholder('Record'),
    GroupsPage(),
    _Placeholder('You'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: SafeArea(child: IndexedStack(index: _index, children: _pages)),
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
  Widget build(BuildContext context) =>
      Center(child: Text(name, style: const TextStyle(color: Colors.white)));
}