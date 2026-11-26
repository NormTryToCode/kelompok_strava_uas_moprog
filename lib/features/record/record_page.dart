import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/manual_activity_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_page.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

class Record extends StatefulWidget {
  const Record({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: 'Record',
        actions: [
          HeaderIconButton(
            icon: Icons.search,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchPage()),
            ),
          ),
          HeaderIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.radio_button_checked,
                size: 56,
                color: Styles.primaryLight,
              ),
              const SizedBox(height: 12),
              const Text(
                'Ready to record your activity',
                style: TextStyle(
                  color: Styles.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start a live session or log a manual activity.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Styles.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ManualActivityPage(),
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Styles.primary,
                  foregroundColor: Styles.textPrimary,
                  shape: const StadiumBorder(),
                ),
                icon: const Icon(Icons.edit_note),
                label: const Text('Log Manual Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}