import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/activity_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/models/manual_activity.dart';
import 'package:kelompok_strava_uas_moprog/features/activity/utils/activity_format.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';

class ManualActivityPage extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const ManualActivityPage({super.key, this.initialDate});

  @override
  ConsumerState<ManualActivityPage> createState() => _ManualActivityPageState();
}

class _ManualActivityPageState extends ConsumerState<ManualActivityPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final TextEditingController _distance = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  late DateTime _date = widget.initialDate ?? DateTime.now();
  ActivityType _type = ActivityType.run;

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
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Styles.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
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

    final activity = ManualActivity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      type: _type,
      date: _date,
      duration: parseDuration(_duration.text)!,
      distanceKm: parseDistance(_distance.text)!,
      notes: _notes.text.trim(),
    );

    await ref.read(activityProvider.notifier).add(activity);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity saved')),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: const AppHeader(title: 'Manual Activity', showBackButton: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              style: const TextStyle(color: Styles.tabActive),
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
                    selectedColor: Styles.accent,
                    labelStyle: const TextStyle(color: Styles.tabActive),
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: _pickDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.white24),
              ),
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white70,
              ),
              title: Text(
                formatDate(_date),
                style: const TextStyle(color: Styles.tabActive),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _duration,
              style: const TextStyle(color: Styles.tabActive),
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
              style: const TextStyle(color: Styles.tabActive),
              decoration: _decoration('Distance (km)', hint: '5.2'),
              validator: (value) => parseDistance(value ?? '') == null
                  ? 'Enter a distance greater than 0'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              style: const TextStyle(color: Styles.tabActive),
              decoration: _decoration('Notes'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Styles.tabActive,
                minimumSize: const Size.fromHeight(52),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}