import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/club_repository.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/location_search_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_1_sport_selection.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_2_club_type.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_3_club_details.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_4_club_privacy.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_5_club_location.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/step_indicator.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/app_buttons.dart';

class ClubCreationPage extends StatefulWidget {
  const ClubCreationPage({super.key});

  static const totalSteps = 5;
  static const maxTypes = 3;

  /// Mengembalikan [Club] yang baru dibuat, atau null kalau dibatalkan.
  static Future<Club?> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<Club>(
      MaterialPageRoute<Club>(builder: (_) => const ClubCreationPage()),
    );
  }

  @override
  State<ClubCreationPage> createState() => _ClubCreationPageState();
}

class _ClubCreationPageState extends State<ClubCreationPage> {
  ClubCreationModel _draft = const ClubCreationModel();
  int _step = 1;
  bool _saving = false;

  String get _nextLabel {
    if (_saving) return 'Creating...';
    if (_step == ClubCreationPage.totalSteps) return 'Create club';
    return 'Continue';
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
    _createClub();
  }

  Future<void> _createClub() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final club = Club.fromCreation(_draft);
      await ClubRepository.instance.addClub(club);
      if (!mounted) return;
      Navigator.of(context).pop(club);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the club. Please try again.')),
      );
    }
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
            _TopBar(
              step: _step,
              totalSteps: ClubCreationPage.totalSteps,
              onClose: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: StepIndicator(
                totalSteps: ClubCreationPage.totalSteps,
                currentStep: _step,
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _buildStep(),
                ),
              ),
            ),
            _BottomBar(
              backLabel: _step == 1 ? 'Cancel' : 'Back',
              nextLabel: _nextLabel,
              onBack: _saving ? null : _onBack,
              onNext: _canProceed && !_saving ? _onNext : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int step;
  final int totalSteps;
  final VoidCallback onClose;

  const _TopBar({
    required this.step,
    required this.totalSteps,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'New club',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            'Step $step of $totalSteps',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Styles.tabInactive,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String backLabel;
  final String nextLabel;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const _BottomBar({
    required this.backLabel,
    required this.nextLabel,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GhostButton(label: backLabel, onPressed: onBack),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: PrimaryButton(label: nextLabel, onPressed: onNext),
          ),
        ],
      ),
    );
  }
}
