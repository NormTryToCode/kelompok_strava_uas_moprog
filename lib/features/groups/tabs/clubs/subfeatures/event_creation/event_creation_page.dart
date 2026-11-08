import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/event_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/event_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/event_form_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/advanced_options_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/attendance_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_basic_fields.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_description_fields.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_details_section.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_location_fields.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/event_creation/widgets/event_schedule_fields.dart';

class EventCreationPage extends StatefulWidget {
  final Club club;

  const EventCreationPage({super.key, required this.club});

  static Future<Event?> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<Event>(
      MaterialPageRoute<Event>(builder: (_) => EventCreationPage(club: club)),
    );
  }

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _form = EventFormController();
  bool _saving = false;

  final _basicKey = GlobalKey();
  final _scheduleKey = GlobalKey();
  final _locationKey = GlobalKey();
  final _detailsKey = GlobalKey();
  final _advancedKey = GlobalKey();
  final _attendanceKey = GlobalKey();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _scrollToFirstError() {
    final firstInvalid = <(GlobalKey, String?)>[
      (_basicKey, _form.nameError ?? _form.sportError),
      (_scheduleKey, _form.dateError),
      (_locationKey, _form.locationError),
      (_detailsKey, _form.kindError ?? _form.paceError),
      (_advancedKey, _form.distanceError),
      (_attendanceKey, _form.capacityError),
    ].where((entry) => entry.$2 != null);

    if (firstInvalid.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = firstInvalid.first.$1.currentContext;
      if (target == null) return;
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 300),
        alignment: 0.05,
      );
    });
  }

  Future<void> _onCreate() async {
    if (_saving) return;

    if (!_form.isValid) {
      _form.update(() => _form.showErrors = true);
      _scrollToFirstError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the highlighted fields')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final event = _form.buildEvent(widget.club);
      await EventRepository.instance.addEvent(event);
      if (!mounted) return;
      Navigator.of(context).pop(event);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the event. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          _Header(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KeyedSubtree(
                    key: _basicKey,
                    child: EventBasicFields(controller: _form),
                  ),
                  const SizedBox(height: 28),
                  KeyedSubtree(
                    key: _scheduleKey,
                    child: EventScheduleFields(controller: _form),
                  ),
                  const SizedBox(height: 28),
                  KeyedSubtree(
                    key: _locationKey,
                    child: EventLocationFields(controller: _form),
                  ),
                  const SizedBox(height: 28),
                  EventDescriptionFields(controller: _form),
                  const SizedBox(height: 36),
                  KeyedSubtree(
                    key: _detailsKey,
                    child: EventDetailsSection(controller: _form),
                  ),
                  const SizedBox(height: 36),
                  KeyedSubtree(
                    key: _advancedKey,
                    child: AdvancedOptionsSection(controller: _form),
                  ),
                  const SizedBox(height: 36),
                  KeyedSubtree(
                    key: _attendanceKey,
                    child: AttendanceSection(controller: _form),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            label: _saving ? 'Creating...' : 'Create',
            onPressed: _saving ? null : _onCreate,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Text(
                'Create Event',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _BottomBar({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Styles.accent.withAlpha(90),
                disabledForegroundColor: Colors.white.withAlpha(110),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
