import 'package:flutter/material.dart';
import '../../core/theme/styles.dart';

class AppFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppFooter({super.key, required this.currentIndex, required this.onTap});

  static Color _color(Set<WidgetState> states) =>
      states.contains(WidgetState.selected) ? Styles.accent : Styles.tabInactive;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Styles.divider)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Styles.background,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith(
            (s) => IconThemeData(color: _color(s)),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (s) => TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _color(s)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Maps'),
            NavigationDestination(icon: Icon(Icons.radio_button_checked), label: 'Record'),
            NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Groups'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'You'),
          ],
        ),
      ),
    );
  }
}