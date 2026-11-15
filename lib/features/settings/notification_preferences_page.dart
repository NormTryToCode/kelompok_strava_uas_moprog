import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_controller.dart';
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

class NotificationPreferencesPage extends StatelessWidget {
  final SettingsController controller;

  const NotificationPreferencesPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: const AppHeader(title: 'Notifications', showBackButton: true),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Theme(
          data: Theme.of(context).copyWith(switchTheme: _switchTheme),
          child: ListView(
            children: [
              const SettingsSectionLabel('PUSH NOTIFICATIONS'),
              for (final pref in NotificationPref.values)
                SwitchListTile(
                  value: controller.isEnabled(pref),
                  onChanged: (value) =>
                      controller.setNotification(pref, value),
                  title: Text(
                    pref.label,
                    style: const TextStyle(
                      color: Styles.tabActive,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}