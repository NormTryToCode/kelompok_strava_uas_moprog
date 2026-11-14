import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/settings_section_label.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/settings_tile.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback? onLogout;

  const SettingsPage({super.key, this.onLogout});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Styles.surface,
        title: const Text(
          'Log out?',
          style: TextStyle(color: Styles.tabActive),
        ),
        content: const Text(
          'You will need to log in again to use your account.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Log out',
              style: TextStyle(color: Styles.accent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onLogout?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: const AppHeader(title: 'Settings', showBackButton: true),
      body: ListView(
        children: [
          const SettingsSectionLabel('ACCOUNT'),
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () => _comingSoon(context),
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy controls',
            onTap: () => _comingSoon(context),
          ),
          SettingsTile(
            icon: Icons.watch_outlined,
            title: 'Connected devices',
            onTap: () => _comingSoon(context),
          ),
          const SettingsSectionLabel('PREFERENCES'),
          SettingsTile(
            icon: Icons.straighten,
            title: 'Units of measurement',
            subtitle: 'Kilometers',
            onTap: () => _comingSoon(context),
          ),
          SettingsTile(
            icon: Icons.notifications_none,
            title: 'Notification preferences',
            onTap: () => _comingSoon(context),
          ),
          const SettingsSectionLabel('SUPPORT'),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Help center',
            onTap: () => _comingSoon(context),
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 16),
          SettingsTile(
            icon: Icons.logout,
            title: 'Log out',
            titleColor: Styles.accent,
            showChevron: false,
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}