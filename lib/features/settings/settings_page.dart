import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
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

  void _openInfoSheet({
    required String title,
    required String body,
    List<String> bullets = const [],
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: const TextStyle(
                  color: Styles.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              if (bullets.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (final item in bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $item',
                      style: const TextStyle(
                        color: Styles.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Styles.primary,
                    foregroundColor: Styles.textPrimary,
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPrivacySheet() {
    final current = ref.read(settingsProvider).privacy;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Styles.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Privacy controls',
                style: TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final option in PrivacyLevel.values)
              ListTile(
                onTap: () {
                  ref.read(settingsProvider.notifier).setPrivacy(option);
                  Navigator.of(sheetContext).pop();
                },
                title: Text(
                  option.label,
                  style: TextStyle(
                    color: option == current
                        ? Styles.primaryLight
                        : Styles.textPrimary,
                    fontWeight: option == current
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                trailing: option == current
                    ? const Icon(Icons.check, color: Styles.primaryLight)
                    : null,
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
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
            icon: Icons.lock_outline,
            title: 'Privacy controls',
            subtitle: settings.privacy.label,
            onTap: _openPrivacySheet,
          ),
          SettingsTile(
            icon: Icons.watch_outlined,
            title: 'Connected devices',
            subtitle: 'GPS & Manual Sync',
            onTap: () => _openInfoSheet(
              title: 'Connected devices',
              body:
                  '${AppBrand.name} uses your device GPS for live tracking and syncs manual activities to Cloud Firestore.',
              bullets: const [
                'Built-in Phone GPS — Ready',
                'Manual Activity Log — Synced',
              ],
            ),
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
            onTap: () => _openInfoSheet(
              title: 'Help center',
              body:
                  'Quick tips for getting the most out of ${AppBrand.name}:',
              bullets: const [
                'Use the + menu on Home or You to log activities or publish club posts.',
                'Switch between Kilometers and Miles anytime under Units of measurement.',
                'Manage alert triggers under Notification preferences.',
              ],
            ),
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: '${AppBrand.name} v1.0.0',
            onTap: () => _openInfoSheet(
              title: 'About ${AppBrand.name}',
              body:
                  '${AppBrand.name} is a collaborative fitness tracking app built with Flutter, Riverpod, and Firebase Cloud Firestore.',
            ),
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