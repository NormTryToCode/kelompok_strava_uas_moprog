import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/auth/auth_providers.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/notification_preferences_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/settings_section_label.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/settings_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/unit_picker_sheet.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final VoidCallback? onLogout;

  const SettingsPage({super.key, this.onLogout});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      if (!ref.read(settingsProvider).isLoaded) {
        ref.read(settingsProvider.notifier).load();
      }
    });
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  void _openNotificationPreferences() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NotificationPreferencesPage(),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Styles.surface,
        title: const Text(
          'Log out?',
          style: TextStyle(color: Styles.primaryLight),
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

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(authServiceProvider).signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
      return;
    }

    if (!mounted) return;

    final handler = widget.onLogout;
    if (handler != null) {
      handler();
      return;
    }

    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: const AppHeader(title: 'Settings', showBackButton: true),
      body: ListView(
        children: [
          const SettingsSectionLabel('ACCOUNT'),
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: _comingSoon,
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy controls',
            onTap: _comingSoon,
          ),
          SettingsTile(
            icon: Icons.watch_outlined,
            title: 'Connected devices',
            onTap: _comingSoon,
          ),
          const SettingsSectionLabel('PREFERENCES'),
          SettingsTile(
            icon: Icons.straighten,
            title: 'Units of measurement',
            subtitle: settings.unit.label,
            onTap: () => showUnitPicker(context, ref),
          ),
          SettingsTile(
            icon: Icons.notifications_none,
            title: 'Notification preferences',
            subtitle:
                '${settings.enabledCount} of ${NotificationPref.values.length} on',
            onTap: _openNotificationPreferences,
          ),
          const SettingsSectionLabel('SUPPORT'),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Help center',
            onTap: _comingSoon,
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            onTap: _comingSoon,
          ),
          const SizedBox(height: 16),
          SettingsTile(
            icon: Icons.logout,
            title: 'Log out',
            titleColor: Styles.accent,
            showChevron: false,
            onTap: _confirmLogout,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
