import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/challenge_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/challenges/widgets/challenge_badge_emblem.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/utils/event_date_format.dart';

class CreateChallengePage extends ConsumerStatefulWidget {
  final Club club;

  const CreateChallengePage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => CreateChallengePage(club: club)),
    );
  }

  @override
  ConsumerState<CreateChallengePage> createState() =>
      _CreateChallengePageState();
}

class _CreateChallengePageState extends ConsumerState<CreateChallengePage> {
  int _step = 0;

  final _titleCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _badgeCodeCtrl = TextEditingController(text: "400'");
  final _targetCtrl = TextEditingController(text: '400');
  final _rewardTitleCtrl = TextEditingController(
    text: 'Official Club Finisher Badge',
  );
  final _descCtrl = TextEditingController();

  late ClubSport _sport;
  ChallengeMetric _metric = ChallengeMetric.movingMinutes;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _sport = widget.club.sport;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _summaryCtrl.dispose();
    _badgeCodeCtrl.dispose();
    _targetCtrl.dispose();
    _rewardTitleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    if (_step == 0) {
      return _titleCtrl.text.trim().isNotEmpty &&
          _badgeCodeCtrl.text.trim().isNotEmpty;
    }
    if (_step == 1) {
      final parsed = double.tryParse(_targetCtrl.text.trim());
      return parsed != null && parsed > 0 && !_endDate.isBefore(_startDate);
    }
    return _rewardTitleCtrl.text.trim().isNotEmpty &&
        _descCtrl.text.trim().isNotEmpty;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2026),
      lastDate: DateTime(2029),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 7));
        }
      } else {
        _endDate = picked;
      }
    });
  }

  void _publish() {
    final target = double.tryParse(_targetCtrl.text.trim()) ?? 100;
    final id = 'ch_${DateTime.now().microsecondsSinceEpoch}';
    final summary = _summaryCtrl.text.trim().isEmpty
        ? 'Complete ${target.toStringAsFixed(0)} (${metricLabel(_metric)}) between ${formatDate(_startDate)} and ${formatDate(_endDate)}.'
        : _summaryCtrl.text.trim();

    final challenge = Challenge(
      id: id,
      title: _titleCtrl.text.trim(),
      summary: summary,
      description: _descCtrl.text.trim(),
      scope: ChallengeScope.club,
      metric: _metric,
      targetValue: target,
      qualifyingSportIds: [_sport.id],
      organizingClubId: widget.club.id,
      organizingClubName: widget.club.name,
      organizingClubMembers: widget.club.memberCount,
      startDate: _startDate,
      endDate: _endDate,
      reward: ChallengeReward(
        badgeCode: _badgeCodeCtrl.text.trim(),
        badgeTitle: _rewardTitleCtrl.text.trim(),
        description: 'Complete the challenge to unlock your digital finisher badge.',
      ),
      participantCount: 1,
      isJoined: true,
      createdAt: DateTime.now(),
    );

    ref.read(challengesProvider.notifier).addChallenge(challenge);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge "${challenge.title}" published!')),
    );
  }

  InputDecoration _fieldDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Styles.textSecondary),
    filled: true,
    fillColor: Styles.surface,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Styles.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Styles.primary),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final stepTitles = ['Basics & Badge', 'Goal & Schedule', 'Reward & Story'];

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        foregroundColor: Styles.textPrimary,
        title: Text(
          'Create Challenge (${_step + 1}/3)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _step ? Styles.primary : Styles.borderStrong,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                Text(
                  stepTitles[_step],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Styles.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                if (_step == 0) ...[
                  Center(
                    child: ChallengeBadgeEmblem(
                      code: _badgeCodeCtrl.text.trim().isEmpty
                          ? '?'
                          : _badgeCodeCtrl.text.trim(),
                      seedId: widget.club.id,
                      sportIcon: _sport.icon,
                      size: 74,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _titleCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco(
                      'Challenge title (e.g. December 400-Min)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _summaryCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco('Short goal summary (optional)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _badgeCodeCtrl,
                    maxLength: 5,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco("Badge code (e.g. 400', 10x, 50K)"),
                  ),
                ] else if (_step == 1) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in ChallengeMetric.values)
                        ChoiceChip(
                          label: Text(metricLabel(m)),
                          selected: _metric == m,
                          showCheckmark: false,
                          selectedColor: Styles.surfaceHighlight,
                          backgroundColor: Styles.surface,
                          side: BorderSide(
                            color: _metric == m ? Styles.primary : Styles.border,
                          ),
                          labelStyle: TextStyle(
                            color: _metric == m
                                ? Styles.textPrimary
                                : Styles.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setState(() => _metric = m),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _targetCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco('Target (${metricLabel(_metric)})'),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(isStart: true),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.textPrimary,
                            side: const BorderSide(color: Styles.borderStrong),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(formatDate(_startDate)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(isStart: false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Styles.textPrimary,
                            side: const BorderSide(color: Styles.borderStrong),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.event, size: 16),
                          label: Text(formatDate(_endDate)),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextField(
                    controller: _rewardTitleCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco('Finisher reward / badge title'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 5,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Styles.textPrimary),
                    decoration: _fieldDeco(
                      'Tell athletes what this challenge is about...',
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Styles.canvas,
              border: Border(top: BorderSide(color: Styles.divider)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (_step > 0) ...[
                    OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Styles.textPrimary,
                        side: const BorderSide(color: Styles.borderStrong),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: !_canProceed
                            ? null
                            : () {
                                if (_step < 2) {
                                  setState(() => _step++);
                                } else {
                                  _publish();
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: Styles.primary,
                          disabledBackgroundColor: Styles.surfaceHighlight,
                          foregroundColor: Styles.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.button),
                          ),
                        ),
                        child: Text(
                          _step < 2 ? 'Next' : 'Publish Challenge',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}