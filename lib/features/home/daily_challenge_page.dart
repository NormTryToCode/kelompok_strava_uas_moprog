import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/shared/widgets/app_header.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class DailyChallengePage extends StatefulWidget {
  final double initialDistanceKm;
  final double targetDistanceKm;

  const DailyChallengePage({
    super.key,
    this.initialDistanceKm = 1.0,
    this.targetDistanceKm = 2.5,
  });

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> {
  late double _currentKm;

  static const List<double> _milestones = [0.5, 1.0, 1.5, 2.0, 2.5];

  @override
  void initState() {
    super.initState();
    _currentKm = widget.initialDistanceKm.clamp(0.0, widget.targetDistanceKm);
  }

  double get _progress =>
      (_currentKm / widget.targetDistanceKm).clamp(0.0, 1.0);

  bool get _isCompleted => _currentKm >= widget.targetDistanceKm;

  void _addProgress(double delta) {
    setState(() {
      _currentKm = (_currentKm + delta).clamp(0.0, widget.targetDistanceKm);
    });
  }

  void _resetProgress() {
    setState(() {
      _currentKm = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();
    final remainingKm =
        (widget.targetDistanceKm - _currentKm).clamp(0.0, widget.targetDistanceKm);
    final accentColor = _isCompleted ? Styles.success : Styles.primary;

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppHeader(
        title: 'Daily Challenge',
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back, color: Styles.textPrimary),
          onPressed: () => Navigator.of(context).pop(_currentKm),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroProgressCard(
              percent: percent,
              remainingKm: remainingKm,
              accentColor: accentColor,
            ),
            const SizedBox(height: 20),
            _buildStatsRow(),
            const SizedBox(height: 20),
            _buildMilestonesCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroProgressCard({
    required int percent,
    required double remainingKm,
    required Color accentColor,
  }) {
    return Container(
      decoration: Styles.cardDecoration(
        withGlow: true,
        borderColor: _isCompleted
            ? Styles.success.withValues(alpha: 0.5)
            : Styles.borderStrong,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  gradient: Styles.radialGlow(
                    color: accentColor,
                    intensity: 0.22,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCompleted
                            ? Styles.success.withValues(alpha: 0.18)
                            : Styles.primaryDark,
                        boxShadow: Styles.glow(
                          color: accentColor,
                          intensity: 0.35,
                          blur: 16,
                        ),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          _isCompleted
                              ? PhosphorIconsRegular.trophy
                              : PhosphorIconsRegular.sneakerMove,
                          size: 28,
                          color: _isCompleted ? Styles.success : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.45),
                              ),
                            ),
                            child: Text(
                              _isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: _isCompleted
                                    ? Styles.success
                                    : Styles.primaryLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Run ${widget.targetDistanceKm.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isCompleted
                                ? 'Daily challenge completed! Streak secured.'
                                : '${remainingKm.toStringAsFixed(1)} km left to keep your streak alive',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Challenge Progress',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Styles.textSecondary,
                      ),
                    ),
                    Text(
                      '${_currentKm.toStringAsFixed(1)} / ${widget.targetDistanceKm.toStringAsFixed(1)} km ($percent%)',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: _isCompleted
                            ? Styles.success
                            : Styles.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 12,
                    backgroundColor: Styles.surfaceHighlight,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final estCalories = (_currentKm * 64).round();
    final estMinutes = (_currentKm * 5.4).round();

    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: Icons.straighten_rounded,
            label: 'Distance',
            value: '${_currentKm.toStringAsFixed(1)} km',
            color: Styles.primaryLight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            icon: Icons.local_fire_department_rounded,
            label: 'Calories',
            value: '$estCalories kcal',
            color: Styles.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricTile(
            icon: Icons.timer_outlined,
            label: 'Active Time',
            value: '$estMinutes min',
            color: Styles.success,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestonesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: Styles.cardDecoration(borderColor: Styles.borderStrong),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHALLENGE CHECKPOINTS',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
              color: Styles.primaryLight,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(_milestones.length, (index) {
            final milestone = _milestones[index];
            final reached = _currentKm >= milestone;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _milestones.length - 1 ? 0 : 12,
              ),
              child: Row(
                children: [
                  Icon(
                    reached
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: reached ? Styles.success : Styles.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reach ${milestone.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            reached ? FontWeight.w700 : FontWeight.w500,
                        color: reached
                            ? Styles.textPrimary
                            : Styles.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    reached ? 'Done' : '${milestone.toStringAsFixed(1)} km',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: reached ? Styles.success : Styles.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isCompleted ? null : () => _addProgress(0.5),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primary,
                  foregroundColor: Styles.textPrimary,
                  disabledBackgroundColor: Styles.surfaceHighlight,
                  disabledForegroundColor: Styles.textMuted,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.directions_run_rounded, size: 18),
                label: Text(
                  _isCompleted ? 'Challenge Complete' : '+0.5 km Progress',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (!_isCompleted) ...[
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => _addProgress(widget.targetDistanceKm),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Styles.primaryLight,
                  side: const BorderSide(color: Styles.borderStrong),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Finish All',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
        if (_currentKm > 0) ...[
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _resetProgress,
            style: TextButton.styleFrom(
              foregroundColor: Styles.textSecondary,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset Progress'),
          ),
        ],
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: Styles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: Styles.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
