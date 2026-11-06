import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/location_search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_1_sport_selection.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_2_club_type.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_3_club_details.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_4_club_privacy.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_5_club_location.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_progress_bar.dart';

class ClubCreationPage extends StatefulWidget {
  const ClubCreationPage({super.key});

  static const totalSteps = 5;
  static const maxTypes = 3;

  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => const ClubCreationPage()),
    );
  }

  @override
  State<ClubCreationPage> createState() => _ClubCreationPageState();
}

class _ClubCreationPageState extends State<ClubCreationPage> {
  ClubCreationModel _draft = const ClubCreationModel();
  int _step = 1; 

  String get _title {
    switch (_step) {
      case 1:
        return 'Sport';
      case 2:
        return 'Club Type';
      case 3:
        return 'Club Info';
      case 4:
        return 'Privacy';
      case 5:
        return 'Location';
      default:
        return '';
    }
  }

  String get _hint {
    switch (_step) {
      case 2:
      case 3:
        return 'You can edit this anytime';
      case 4:
        return '';
      default:
        return 'You can always change this later';
    }
  }

  String get _nextLabel {
    if (_step == 2 && _draft.types.isEmpty) return 'Pick at least 1';
    if (_step == ClubCreationPage.totalSteps) return 'Create Club';
    return 'Next';
  }

  bool get _canProceed {
    if (_step == 2) return _draft.types.isNotEmpty;
    if (_step == 3) return _draft.name.trim().isNotEmpty;
    if (_step == 5) return _draft.isGlobal || _draft.location != null;
    return true;
  }

  void _toggleType(ClubType type) {
    final updated = List<ClubType>.of(_draft.types);
    final index = updated.indexWhere((t) => t.id == type.id);

    if (index >= 0) {
      updated.removeAt(index);
    } else if (updated.length < ClubCreationPage.maxTypes) {
      updated.add(type);
    }

    setState(() => _draft = _draft.copyWith(types: updated));
  }

  void _onPickPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo upload is coming soon')),
    );
  }

  Future<void> _onPickLocation() async {
    final result = await LocationSearchPage.open(context);
    if (result == null || !mounted) return;
    setState(() => _draft = _draft.copyWith(isGlobal: false, location: result));
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return Step1SportSelection(
          selected: _draft.sport,
          onChanged: (sport) =>
              setState(() => _draft = _draft.copyWith(sport: sport)),
        );
      case 2:
        return Step2ClubType(
          selected: _draft.types,
          maxSelection: ClubCreationPage.maxTypes,
          onToggle: _toggleType,
        );
      case 3:
        return Step3ClubDetails(
          name: _draft.name,
          description: _draft.description,
          onNameChanged: (value) =>
              setState(() => _draft = _draft.copyWith(name: value)),
          onDescriptionChanged: (value) =>
              setState(() => _draft = _draft.copyWith(description: value)),
          onPickPhoto: _onPickPhoto,
        );
      case 4:
        return Step4ClubPrivacy(
          selected: _draft.privacy,
          onChanged: (privacy) =>
              setState(() => _draft = _draft.copyWith(privacy: privacy)),
        );
      case 5:
        return Step5ClubLocation(
          isGlobal: _draft.isGlobal,
          location: _draft.location,
          onSelectGlobal: () =>
              setState(() => _draft = _draft.copyWith(isGlobal: true)),
          onPickLocation: _onPickLocation,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _onNext() {
    if (_step < ClubCreationPage.totalSteps) {
      setState(() => _step++);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Club data is ready, database not connected yet')),
    );
  }

  void _onBack() {
    if (_step > 1) {
      setState(() => _step--);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: _title,
              onBack: _onBack,
              onClose: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: StepProgressBar(
                totalSteps: ClubCreationPage.totalSteps,
                currentStep: _step,
              ),
            ),
            Expanded(child: _buildStep()),
            _BottomBar(
              hint: _hint,
              label: _nextLabel,
              onNext: _canProceed ? _onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const _Header({
    required this.title,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'CLOSE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String hint;
  final String label;
  final VoidCallback? onNext;

  const _BottomBar({
    required this.hint,
    required this.label,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hint.isNotEmpty) ...[
            Text(
              hint,
              style: const TextStyle(fontSize: 15, color: Styles.tabInactive),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: onNext,
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
        ],
      ),
    );
  }
}
