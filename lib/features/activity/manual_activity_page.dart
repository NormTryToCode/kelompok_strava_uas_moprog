import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_list_page.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/utils/activity_format.dart';
import 'package:kelompok_strava_uas_moprog/features/home/providers/weekly_activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/notifications/notification_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/settings/settings_provider.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/header_icon_button.dart';

class ManualActivityPage extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final ManualActivity? existing;

  const ManualActivityPage({
    super.key,
    this.initialDate,
    this.existing,
  });

  @override
  ConsumerState<ManualActivityPage> createState() => _ManualActivityPageState();
}

class _ManualActivityPageState extends ConsumerState<ManualActivityPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _duration;
  late final TextEditingController _distance;
  late final TextEditingController _notes;
  late DateTime _date;
  late ActivityType _type;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _duration = TextEditingController(
      text: existing == null ? '' : _formatDurationInput(existing.duration),
    );
    _distance = TextEditingController(
      text: existing == null ? '' : existing.distanceKm.toString(),
    );
    _notes = TextEditingController(text: existing?.notes ?? '');
    _date = existing?.date ?? widget.initialDate ?? DateTime.now();
    _type = existing?.type ?? ActivityType.run;
  }

  String _formatDurationInput(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes}';
  }

  int _estimateCalories(ActivityType type, double distanceKm) {
    final kcalPerKm = switch (type) {
      ActivityType.run || ActivityType.hike => 62,
      ActivityType.walk => 45,
      ActivityType.ride => 35,
      ActivityType.swim || ActivityType.workout => 75,
    };
    return (distanceKm * kcalPerKm).round();
  }

  int _estimateSteps(ActivityType type, double distanceKm) {
    return switch (type) {
      ActivityType.run || ActivityType.walk || ActivityType.hike =>
        (distanceKm * 1300).round(),
      ActivityType.ride || ActivityType.swim || ActivityType.workout => 0,
    };
  }

  @override
  void dispose() {
    _title.dispose();
    _duration.dispose();
    _distance.dispose();
    _notes.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Styles.textSecondary),
      hintStyle: const TextStyle(color: Styles.textMuted),
      filled: true,
      fillColor: Styles.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Styles.primary),
      ),
    );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: _date.isAfter(today) ? _date : today,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final unit = ref.read(settingsProvider).unit;
    final rawDistance = parseDistance(_distance.text)!;
    final distanceKm =
        unit == SettingsDistanceUnit.miles ? rawDistance / 0.621371 : rawDistance;

    final activity = ManualActivity(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      type: _type,
      date: _date,
      duration: parseDuration(_duration.text)!,
      distanceKm: distanceKm,
      notes: _notes.text.trim(),
    );

    await ref.read(activityProvider.notifier).add(activity);
    if (!_isEditing) {
      ref.read(notificationsProvider.notifier).notifyActivityLogged(
            title: activity.title,
            distanceLabel: formatDistanceWithUnit(activity.distanceKm, unit),
          );
      try {
        await ref.read(weeklyActivityProvider.notifier).addRecordedActivity(
              distanceKm: activity.distanceKm,
              calories: _estimateCalories(activity.type, activity.distanceKm),
              steps: _estimateSteps(activity.type, activity.distanceKm),
              date: activity.date,
            );
      } catch (_) {
        // Lewati jika Firebase belum diinisialisasi (misalnya di widget test).
      }
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Activity updated' : 'Activity saved'),
      ),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(settingsProvider).unit;
    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: _isEditing ? 'Edit Activity' : 'Manual Activity',
        showBackButton: true,
        actions: [
          if (!_isEditing)
            HeaderIconButton(
              icon: Icons.history,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ActivityListPage(),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration('Title', hint: 'Morning run'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final type in ActivityType.values)
                  ChoiceChip(
                    label: Text(type.label),
                    selected: _type == type,
                    selectedColor: Styles.primary,
                    backgroundColor: Styles.surface,
                    labelStyle: TextStyle(
                      color: _type == type
                          ? Styles.textPrimary
                          : Styles.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: _pickDate,
              tileColor: Styles.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Styles.border),
              ),
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: Styles.primaryLight,
              ),
              title: Text(
                formatDate(_date),
                style: const TextStyle(color: Styles.textPrimary),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _duration,
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration('Duration', hint: '45 or 1:30'),
              validator: (value) => parseDuration(value ?? '') == null
                  ? 'Use minutes or h:mm, e.g. 45 or 1:30'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _distance,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration(
                'Distance (${unit.abbreviation})',
                hint: '5.2',
              ),
              validator: (value) => parseDistance(value ?? '') == null
                  ? 'Enter a distance greater than 0'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              style: const TextStyle(color: Styles.textPrimary),
              decoration: _decoration('Notes'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.primary,
                foregroundColor: Styles.textPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: const StadiumBorder(),
              ),
              child: Text(
                _isEditing ? 'Update' : 'Save',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}