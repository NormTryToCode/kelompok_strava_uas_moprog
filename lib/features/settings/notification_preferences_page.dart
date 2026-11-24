import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/widgets/settings_section_label.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

final SwitchThemeData _switchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color?>(
    (states) => states.contains(WidgetState.selected) ? Styles.accent : null,
  ),
  trackColor: WidgetStateProperty.resolveWith<Color?>(
    (states) => states.contains(WidgetState.selected)
        ? Styles.accent.withAlpha(90)
        : null,
  ),
);

class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: const AppHeader(title: 'Notifications', showBackButton: true),
      body: Theme(
        data: Theme.of(context).copyWith(switchTheme: _switchTheme),
        child: ListView(
          children: [
            const SettingsSectionLabel('PUSH NOTIFICATIONS'),
            for (final pref in NotificationPref.values)
              SwitchListTile(
                value: settings.isEnabled(pref),
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .setNotification(pref, value),
                title: Text(
                  pref.label,
                  style: const TextStyle(
                    color: Styles.primaryLight,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

